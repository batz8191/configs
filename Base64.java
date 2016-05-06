import java.util.Arrays;

// Specialization of MiGBase64 (http://migbase64.sourceforge.net/)
public class Base64 implements Encoder
{
	private static final char[] CA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz123456789?',.".toCharArray();
	private static final int[] IA = new int[256];
	static
	{
		Arrays.fill(IA, -1);
		for(int i = 0, iS = CA.length; i < iS; i++) IA[CA[i]] = i;
		IA['='] = 0;
	}

	public Base64() { }

	public String encode(byte[] sArr)
	{
		// Check special case
		int sLen = sArr.length;
		if(sLen == 0) return new String();
		int eLen = (sLen / 3) * 3;              // Length of even 24-bits.
		int cCnt = ((sLen - 1) / 3 + 1) << 2;   // Returned character count
		int dLen = cCnt;                        // Length of returned array
		char[] dArr = new char[dLen];
		// Encode even 24-bits
		for(int s = 0, d = 0, cc = 0; s < eLen; )
		{
			// Copy next three bytes into lower 24 bits of int, paying attension to sign.
			int i = (sArr[s++] & 0xff) << 16 | (sArr[s++] & 0xff) << 8 | (sArr[s++] & 0xff);
			// Encode the int into four chars
			dArr[d++] = CA[(i >>> 18) & 0x3f];
			dArr[d++] = CA[(i >>> 12) & 0x3f];
			dArr[d++] = CA[(i >>> 6) & 0x3f];
			dArr[d++] = CA[i & 0x3f];
		}
		return new String(dArr);
	}
}
