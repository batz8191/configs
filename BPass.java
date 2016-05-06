import java.io.*;
import java.math.BigInteger;
import java.net.URL;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.Arrays;

public class BPass
{
	class Site
	{
		private static final int DEFAULT_LENGTH = 17;

		public String name;
		public char[] invalidChars;
		public char[] requiredChars;
		public int maxLength;
		public String seed;

		Site(String name, char[] invalidChars, char[] requiredChars, int maxLength, String seed)
		{
			this.name = name;
			this.invalidChars = invalidChars == null ? new char[]{} : invalidChars;
			this.requiredChars = requiredChars == null ? new char[]{} : requiredChars;
			this.maxLength = maxLength;
			if(maxLength == 0) this.maxLength = DEFAULT_LENGTH;
			this.seed = seed;
		}
	}

	private static final char[] safeChars = "aBCdeFGhiJKmnoPqRStUvWXYz".toCharArray();
	private static String OK = "ok";

	// TODO make this not static...
	// TODO Need a salt in the config file
	private static String host;
	private static JPasswordField passwordField;
	private static JTextField hostField;
	private static JFrame controllingFrame;
	private Random rand;

	private Map<String, Site> sites;

	public BPass() {
		sites = new HashMap<String, Site>();
	}

	public void parseSites(String config)
	{
		try
		{
			BufferedReader input =  new BufferedReader(new FileReader(config));
			String line;
			while((line = input.readLine()) != null)
			{
				if(line.startsWith("#")) continue;
				String[] opts = line.split("\\s+");
				if(opts.length != 4 && opts.length != 5)
				{
					System.err.println("Incorrect number of fields \"" + line + "\" " + opts.length);
					continue;
				}
				if(opts[1].equals("*")) opts[1] = "";
				if(opts[2].equals("*")) opts[2] = "";
				int maxLen = Integer.parseInt(opts[3]);
				String seed = "";
				if(opts.length == 5) seed = opts[4];
				sites.put(opts[0], new Site(opts[0], opts[1].toCharArray(), opts[2].toCharArray(), maxLen, seed));
			}
			input.close();
		}
		catch(IOException ex)
		{
			System.err.println("Could not read config");
			System.exit(1);
		}
	}

	public Site get(String host) { return sites.get(host); }

	public void testDiceware(MessageDigest sha, Site site, byte[] domain, byte[] initPass)
	{
		final char[] specialChars = "!@',.?()".toCharArray();
		Diceware dice = new Diceware();
		dice.init();
		String pass = dice.encode(initPass, site.maxLength, sha);
		BigInteger special = new BigInteger(domain);
		int s = (int)special.mod(BigInteger.valueOf(pass.length())).longValue();
		int ss = (int)special.mod(BigInteger.valueOf(specialChars.length)).longValue();
		String out = pass.substring(0, s) + specialChars[ss] + pass.substring(s+1);
		System.out.print(out);
	}

	public void testEncode(Encoder enc, Site site, byte[] domain, byte[] initPass)
	{
		String encPass = enc.encode(initPass);
		if(site.maxLength > 0) {
			encPass = encPass.substring(0, site.maxLength);
		}
		BigInteger x = new BigInteger(domain);
		rand = new Random(x.longValue());
		if(site.invalidChars.length > 0)
		{
			int j = (int)x.mod(BigInteger.valueOf(safeChars.length)).longValue();
			for(char c : site.invalidChars)
			{
				encPass = encPass.replace(c, safeChars[j++]);
				if(j >= safeChars.length) j = 0;
			}
		}
		if(site.requiredChars.length > 0)
		{
			// TODO Instead of rand should I use
			// i = x.mod(encPass.length())? It'll be safe against javac
			// changes to rand
			for(char c : site.requiredChars) {
				int i = rand.nextInt(encPass.length());
				encPass = encPass.substring(0, i) + c + encPass.substring(i+1);
			}
		}
		System.out.print(encPass);
	}

	public String putFinalPass(String host, String config, char[] master)
	{
		parseSites(config);
		String masterPass = new String(master);
		Site site = get(host);
		if(site == null) return "Could not find the host " + host;
		MessageDigest sha;
		try
		{
			sha = MessageDigest.getInstance("SHA-256");
		}
		catch(java.security.NoSuchAlgorithmException e)
		{
			return "Could not load algorithm SHA";
		}
		sha.update(site.seed.getBytes());
		sha.update(host.getBytes());
		byte[] domain = sha.digest();
		sha.reset();
		sha.update(domain);
		sha.update(masterPass.getBytes());
		byte[] initPass = sha.digest();
		testEncode(new Base64(), site, domain, initPass);
		Arrays.fill(master, '0');
		return null;
	}


	public static void main(String[] args)
	{
		// TODO add a -r option to give a random salt (base64 encoded output)
		if(args.length < 2)
		{
			System.err.println("Usage: Prog <config> <url> [pass]");
			return;
		}
		final String config = args[0];
		String surl = args[1];
		URL url;
		try
		{
			url = new URL(surl);
			host = url.getHost();
		}
		catch(java.net.MalformedURLException e)
		{
			System.err.println("Could not parse host " + surl);
			host = args[1];
		}
		if(args.length > 2)
		{
			BPass test = new BPass();
			String err = test.putFinalPass(host, config, args[2].toCharArray());
			if(err != null)
			{
				System.err.println(err);
				return;
			}
		}
		else
		{
			EventQueue.invokeLater(new Runnable() {
				public void run() {
					Font font = new Font("Serif", Font.PLAIN, 40);
					ActionListener al = new ActionListener() {
						public void actionPerformed(ActionEvent e) {
							String cmd = e.getActionCommand();
							if(OK.equals(cmd))
							{
								char[] input = passwordField.getPassword();
								String host = hostField.getText();
								BPass test = new BPass();
								String err = test.putFinalPass(host, config, input);
								if(err != null)
								{
									JOptionPane.showMessageDialog(controllingFrame,
											err,
											"Error Message",
											JOptionPane.ERROR_MESSAGE);
								}
								else
								{
									passwordField.selectAll();
									System.exit(0);
								}
							}
						}
					};
					controllingFrame = new JFrame("Master Password");
					controllingFrame.setFont(font);
					controllingFrame.setLayout(new GridLayout(3, 2));
					JLabel label = new JLabel("Site");
					label.setFont(font);
					controllingFrame.add(label);
					hostField = new JTextField(host);
					hostField.setFont(font);
					hostField.setActionCommand(OK);
					hostField.addActionListener(al);
					controllingFrame.add(hostField);
					label = new JLabel("Password");
					label.setFont(font);
					controllingFrame.add(label);
					passwordField = new JPasswordField("");
					passwordField.setFont(font);
					passwordField.setActionCommand(OK);
					passwordField.addActionListener(al);
					controllingFrame.addWindowFocusListener(new WindowAdapter() {
						public void windowGainedFocus(WindowEvent e) {
							passwordField.requestFocusInWindow();
						}
					});
					controllingFrame.add(passwordField);
					JButton okButton = new JButton("OK");
					okButton.setActionCommand(OK);
					okButton.addActionListener(al);
					okButton.setFont(font);
					controllingFrame.add(okButton);
					controllingFrame.pack();
					passwordField.requestFocusInWindow();
					controllingFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
					controllingFrame.setVisible(true);
				}
			});
		}
	}
}
