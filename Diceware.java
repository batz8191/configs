import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.util.ArrayList;

public class Diceware implements Encoder
{
	public static ArrayList<String> words;

	public Diceware() { }

	public static void init()
	{
		words = new ArrayList<String>();
		loadWordlist();
	}

	private static void loadWordlist()
	{
		try
		{
			BufferedReader input =  new BufferedReader(new FileReader("diceware.wordlist.asc"));
			String line;
			while((line = input.readLine()) != null)
			{
				words.add(line);
			}
			input.close();
		}
		catch(IOException ex)
		{
			System.err.println("Could not read wordlist file");
			System.exit(1);
		}
	}

	public String encode(final byte[] bytes)
	{
		MessageDigest sha;
		try
		{
			sha = MessageDigest.getInstance("SHA-256");
		}
		catch(java.security.NoSuchAlgorithmException e)
		{
			System.err.println("Could not load algorithm SHA");
			return null;
		}
		return encode(bytes, -1, sha);
	}

	static public String encode(final byte[] bytes, int maxLen, MessageDigest sha)
	{
		StringBuilder sb = new StringBuilder();
		int length = 0;
		for(int i = 0; i < 10; ++i)
		{
			sha.reset();
			sha.update(bytes);
			byte[] p = sha.digest(String.valueOf(i).getBytes());
			BigInteger word = new BigInteger(p);
			int x = (int)word.mod(BigInteger.valueOf(words.size())).longValue();
			String w = words.get(x);
			sb.append(w);
			length += w.length();
			if(maxLen > 0 && length > maxLen) break;
		}
		return sb.toString();
	}
}
