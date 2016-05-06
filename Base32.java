public class Base32 implements Encoder
{
	private static final String base32Chars = "abcDeFghIJkLMnOpqrsTuvWxyz',.?! ";

	public Base32() { }

	public String encode(final byte[] bytes)
	{
		int i = 0, index = 0, digit = 0;
		int currByte, nextByte;
		StringBuffer base32 = new StringBuffer((bytes.length + 7) * 8 / 5);
		while(i < bytes.length)
		{
			currByte = (bytes[i] >= 0) ? bytes[i] : (bytes[i] + 256); // unsign
			/* Is the current digit going to span a byte boundary? */
			if(index > 3)
			{
				if((i + 1) < bytes.length)
				{
					nextByte = (bytes[i + 1] >= 0) ? bytes[i + 1] : (bytes[i + 1] + 256);
				}
				else
				{
					nextByte = 0;
				}
				digit = currByte & (0xFF >> index);
				index = (index + 5) % 8;
				digit <<= index;
				digit |= nextByte >> (8 - index);
				i++;
			}
			else
			{
				digit = (currByte >> (8 - (index + 5))) & 0x1F;
				index = (index + 5) % 8;
				if (index == 0) i++;
			}
			base32.append(base32Chars.charAt(digit));
		}
		return base32.toString();
	}
}
