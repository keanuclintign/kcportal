/*
 *	$Source$
 *	$Name$
 *	$Revision: 79962 $
 *	$Date: 2014-03-07 01:03:29 +0530 (Fri, 07 Mar 2014) $
 *
 *	Copyright (c) 2002 - 2005, SmartEquip, Inc.
 *	83 East Avenue, Suite 101, Norwalk, CT 06851
 *
 *	Proprietary
 *	All Rights Reserved
 */
package com.nyu.util;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import java.util.Vector;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 *  This class contains static methods for some simple (stateless) utility
 *  functions related to String manipulation.
 */
public class StringUtils extends org.apache.commons.lang.StringUtils
{

	private static Logger PERF_LOGGER = Logger.getLogger("performanceLog");
	 // Logger
	private static final Logger LOGGER =
			Logger.getLogger(StringUtils.class);
    /**
     *  Encodes the input String into "HTML safe" format using entity
     *  references and escape sequences.  <b>This method will be deprecated
     *  soon</b>.
     *
     *  <p>
     *  Note that this method encode the apostrophy into
     *  <code>&amp;apos;</code>  which is not an HTML standard, but since
     *  this is an existing method used by a lot of old code, we don't
     *  change it for now, and may deprecate / remove it later.  <b>Please
     *  use  {@link #escapeXML(String)}  for future applications</b>
     *  </p>
     *
     * @param   inputString the string to be encoded.
     * @return  the string after encoding.
     */
    public static String escapeHTML(String inputString) {

        if (inputString == null) {
            return  "";
        }

        StringBuffer outputBuffer = new StringBuffer();
        for (int i = 0; i < inputString.length(); i++) {

            char ch = inputString.charAt(i);

            switch (ch) {

                case '"':
                    outputBuffer.append("&quot;");
                    break;

                case '&':
                    outputBuffer.append("&amp;");
                    break;

                case '<':
                    outputBuffer.append("&lt;");
                    break;

                case '>':
                    outputBuffer.append("&gt;");
                    break;

                case '\'':
                    outputBuffer.append("&apos;");
                    break;

                default:
                    if (ch > 126) {

                        int in = ch;
                        String s = (in) + "";
                        outputBuffer.append("&#" + s + ";");

                    } else {

                        outputBuffer.append(ch);
                    }
                    break;
            }
        }

        return  outputBuffer.toString();
    }


    /**
     *  Encodes the input String into "HTML safe" format using entity
     *  references and escape sequences.
     *
     *  <p>
     *  Note that this method encode the apostrophy into
     *  <code>&amp;#39;</code>.
     *  </p>
     *
     * @param   inputString the string to be encoded.
     * @return  the string after encoding.
     */
    public static String encodeHTML(String inputString) {

        if (inputString == null) {
            return  "";
        }

        StringBuffer outputBuffer = new StringBuffer();
        for (int i = 0; i < inputString.length(); i++) {

            char ch = inputString.charAt(i);

            switch (ch) {

                case '"':
                    outputBuffer.append("&quot;");
                    break;

                case '&':
                    outputBuffer.append("&amp;");
                    break;

                case '<':
                    outputBuffer.append("&lt;");
                    break;

                case '>':
                    outputBuffer.append("&gt;");
                    break;

                case '\'':
                    outputBuffer.append("&#39;");
                    break;
                    
                case ',':
                    outputBuffer.append("&#44;");
                    break;

                default:
                    if (ch > 126) {

                        int in = ch;
                        String s = (in) + "";
                        outputBuffer.append("&#" + s + ";");

                    } else {

                        outputBuffer.append(ch);
                    }
                    break;
            }
        }

        return  outputBuffer.toString();
    }

    /**
     * 
     * 	Escapes the characters in a String using XML entities.
	 *	For example: "bread" & "butter" => &quot;bread&quot; &amp; &quot;butter&quot;.
	 *	Supports only the five basic XML entities (gt, lt, quot, amp, apos). Does not support DTDs or external entities.
	 *  Returns empty string if inputString is null. 
     * @param inputString
     * @return
     */
    public static String escapeXML(String inputString) {
    	return (inputString != null) ? StringEscapeUtils.escapeXml(inputString) : "";
    }

    /**
     *  Decodes our proprietary encoding of carriage return
     *  <code>|n</code>  into HTML line break  <code>&lt;br&gt;</code>
     *
     *  <p>
     *  Note that this method assumes our proprietary encoding of carriage
     *  return is a combination of one vertical bar followed by one lower
     *  case n, case sensitive, with the vertical bar having US ASCII code
     *  deciaml  <code>124</code>  and hex  <code>7C</code>
     *  </p>
     *
     * @param   inputString the string to be decoded.
     * @return  the string after decoding.
     */
    public static String decodeCarriageReturnToHTML(String inputString) {

        if (inputString == null) {
            return  "";
        }

        return  inputString.replaceAll("\\x7Cn", "<br>");
    }


    /**
     *  Encodes the input String into "HTML safe" format using entity
     *  references and escape sequences, then decodes the our proprietary
     *  encoding of carriage return  <code>|n</code>  into HTML line break
     *  <code>&lt;br&gt;</code>
     *
     * @param   inputString the string to be encoded.
     * @return  the string after encoding.
     * @see #encodeHTML(String)
     * @see #decodeCarriageReturnToHTML(String)
     */
    public static String encodeForHTMLEmail(String inputString) {

        // The order of method call is important.
        // If reversed, the line break tags will be encoded into display
        // strings, which is incorrect
        return  decodeCarriageReturnToHTML(encodeHTML(inputString));
    }



   public static String stripLeadingSpaces(String s)
   {
      String rets;
      int i;
      for (i = 0; i < s.length() && Character.isWhitespace(s.charAt(i)); i++);
      try{
         rets = s.substring(i);
      }
      catch (IndexOutOfBoundsException ioobe)
      {
         rets = "";
      }

      return rets;
   }


    /**
     * Checks if a string is all digits (without decimal point)
     * @param s -
     * @returns boolean
     */
    public static boolean isAllDigits(String s)
    {
       for (int i = 0; i < s.length(); i++)
           if (!Character.isDigit(s.charAt(i))) return false;
        return true;
    }
    public static boolean emptyInput(String in)
    {
        if (in == null || in.length() == 0 || in.trim().length() == 0)
            return true;
        return false;
    }
    /*
    ** No Nulls
    */
    public static String noNull(String inStr)
    {
        return (inStr == null)?"":inStr.trim();
    }
    public static String noNullCheck(String inStr)
    {
        return (inStr == null)?"":inStr;
    }

    public static String nullBlankToZero(String inStr)
    {
        return (inStr == null || inStr.length() ==0)?"0":inStr.trim();
    }

    public static String blankToNull(String inStr)
    {
        return (inStr != null && inStr.length() == 0)? null : inStr;
    }

    public static boolean nullOrBlank(String inStr)
    {
        if(null == inStr || inStr.trim().length() == 0)
            return true;
        else
            return false;
    }

    /**
     * Validates and formats US and Canadian phone numbers
     * by inserting dashes after the 3-d and 6-th digits
     *
     * @param phone number to format
     * @return the formatted phone number if it's valid or null otherwise
     */
    public static String formatPhone(String phone)
    {
    	if(phone == null){
    		return "";
    	}
    	phone = phone.replaceAll("[^0-9]", "");
    	int phLen = phone.length();
    	if(phLen == 11){
    		phone = phone.substring(1,phLen);
    	} else if(phLen > 10){
    		LOGGER.error("Phone number cannot be greater than 10 digit. Returning null.");
    		return "";
    	} else if(phLen < 10){
    		LOGGER.error("Phone number cannot be less that 10 digit. Returning null.");
    		return "";
    	}

    	StringBuffer buff = new StringBuffer(phone);
    	buff.insert(3, '-');
    	buff.insert(7, '-');
    	return buff.toString();
    }

    /**
     * Replaces HTML-reserved characters in a string with their HTML
     * equivalents (e.g., '&' becomes '&amp;').
     * This formats it properly for use in an HTML file.
     * (HTML reserved characters are "&<>.)
     *
     * @param value the string to format.
     * @returns the formatted string.
     */


   /**************************************************************************
    * removeMultipleSpace
    * @param value -
    * @return strval
    **************************************************************************/
    public static String removeMultipleSpace(String value)
    {
        if (value == null) return "";
        StringBuffer strval = new StringBuffer();
        for (int i = 0; i < value.length(); i++)
        {
            char ch = value.charAt(i);
            if(i > 0 && value.charAt(i) == ' ' && value.charAt(i-1) == ' ')
                continue;
            strval.append(value.charAt(i));
        }
        return strval.toString();
    }

   /**************************************************************************
    * replace
    * @param sourceString - String being operated on
    * @param stringToReplace - What to look for
    * @param replacementString - What to replace it with
    * @return returnString
    **************************************************************************/
  /* 10/28/06 let lang.StringUtil to be the one to use.
   public static String replace(String sourceString, String stringToReplace, String replacementString)
   {
      String returnString = null;
      if(replacementString == null) replacementString = "";
      returnString = sourceString;
      StringBuffer sb = new StringBuffer();
      if ((sourceString != null) && (stringToReplace != null) && (replacementString != null))
      {
         int begin = 0;
         int next = sourceString.indexOf(stringToReplace);
         int stringToReplaceLength = stringToReplace.length();
         if(next >=0)
         {
             while(next >= 0)
            {
               sb.append(sourceString.substring(begin, next) + replacementString);
               begin = next + stringToReplaceLength;
               next = sourceString.indexOf(stringToReplace, begin);
            }
            sb.append(sourceString.substring(begin));
         }
      }
      if(sb.length() > 0)
        returnString = sb.toString();
      return returnString;
   }
*/
   /**************************************************************************
    * extractXMLvalue - Extract textual value from a specified XML tag
    * @param ele - contains the XML encoded data
    * @param sXMLTagName - name of the XML tag that contains the data element
    * @return sExtrcatedValue - string value extracted from the XML tag
    **************************************************************************/
   public static String extractXMLvalue(Element ele, String sXMLTagName)
   {
      String sExtrcatedValue = "";
      try
      {
         NodeList orderDescNodeList = ele.getElementsByTagName(sXMLTagName);
         //Node orderDescNode = orderDescNodeList.item(0).getFirstChild();
         //sExtrcatedValue = orderDescNode.getNodeValue().toString();
         sExtrcatedValue = getFirstNodeValue(orderDescNodeList);
         if (sExtrcatedValue == null)
            sExtrcatedValue = "";
      }
      catch (Exception e)
      {
         sExtrcatedValue = "";
         LOGGER.error(e.getMessage()+ " sXMLTagName = " + sXMLTagName, e );
      }
      return sExtrcatedValue;
   }
   /**
    *
    * Method Added to take care of Spl chars giving a problem in <comment> tag of
    * <SubmitPO-request> - multiquip
    * Front end will send in input as unencoded HTML like
    * this is line1'|nthis is line2&|nthis is line3&^%$##@
    *
    * */
   public static String extractXMLvalueSplChars(Element ele, String sXMLTagName)
   {
      String sExtrcatedValue = "";
      try
      {
         NodeList orderDescNodeList = ele.getElementsByTagName(sXMLTagName);
      //   Node x = (Node)orderDescNodeList.item(0);
         //sExtrcatedValue = x.toString();
         sExtrcatedValue = getFirstNodeValue(orderDescNodeList);

         sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"<"+sXMLTagName+">","");
         sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"<"+"/"+sXMLTagName+">","");
         sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"<"+sXMLTagName+"/"+">","");
         sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"<"+sXMLTagName+" /"+">","");
         sExtrcatedValue = decodeHTML(sExtrcatedValue);


         if (sExtrcatedValue == null)
            sExtrcatedValue = "";
      }
      catch (Exception e)
      {
         sExtrcatedValue = "";
         LOGGER.error(e.getMessage()+ " sXMLTagName = " + sXMLTagName, e);
      }
      return sExtrcatedValue;
}


public static String decodeHTML(String sExtrcatedValue) {
	sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&amp;","&");
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&gt;",">");
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&lt;","<");
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&quot;", "\"");
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&#39;", "'");
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&apos;", "'");
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue, "&APOS;", "'");
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&AMP;","&");

	 // Capital letters as JLG is converting all characters to Capital
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&GT;",">");
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&LT;","<");
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&QUOT;", "\"");
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&#39;", "'");
	 sExtrcatedValue = StringUtils.replace(sExtrcatedValue,"&#44;", ",");
	return sExtrcatedValue;
}

   // parse phone to area code and phone field

   // Changed July 5, 2006 to
   //Check if Phone Number is 10 digits
   //If less than 10, add 0's before
   //chk if everyone of them is a digit



   /**************************************************************************
    * padCustNum - Make sure the customer number is always 10 characters long
    *              and is zero filled (if necessary)
    * @param sCustNum -
    * @return sPaddedCustNum
    **************************************************************************/
   public static String padCustNum(String sCustNum)
   {
      String sPaddedCustNum = null;
      String sZeros = "0000000000";
      // Figure out how many zeros to add
      int iLength = 10 - sCustNum.length();
      sPaddedCustNum = sZeros.substring(0, iLength) + sCustNum;
      return sPaddedCustNum;
   }

   public static String padNumberwithZero(String sNum,int length)
   {
      String sPaddedNum = null;
      String sZeros = "0000000000000";
      // Figure out how many zeros to add
      int iLength = length - sNum.length();
      sPaddedNum = sZeros.substring(0, iLength) + sNum;
      return sPaddedNum;
   }


   /*
   ** Append char to a string until certain len
   */
   public static String appendChar(String in, int len, char ac)
   {
       String ins = noNull(in);
       StringBuffer sb = new StringBuffer();
       sb.append(ins);
       if(ins.length() < len)
       {
           for(int i = 0; i < len-ins.length(); i++)
               sb.append(ac);
       }

       return sb.toString();
   }
   /***************************************************************************
    * stringVectorToString -
    * @param v - String vector
    * @param delim - delimiter betwen each string
    * @return String
    **************************************************************************/
   public static String stringVectorToString(Vector v, String delim)
   {

       StringBuffer sb = new StringBuffer();

       for(int i = 0; i < v.size(); i++)
       {
           String s = (String)v.get(i);
           if(i != 0)
           {
               sb.append(delim);
           }
           sb.append(s);
       }
       return sb.toString();
   }
   
   /***************************************************************************
    * stringListToString -
    * @param strList - String List
    * @param delim - delimiter betwen each string
    * @return String
    **************************************************************************/
   public static String stringListToString(List<String> strList, String delim)
   {

       StringBuffer sb = new StringBuffer();

       for(int i = 0; i < strList.size(); i++)
       {
           String s = (String)strList.get(i);
           if(i != 0)
           {
               sb.append(delim);
           }
           sb.append(s);
       }
       return sb.toString();
   }
   /***************************************************************************
    * stringToVector -
    * @param s - String with delimiter
    * @param delim - delimiter betwen each string
    * @return Vector
    **************************************************************************/
   public static Vector stringToVector(String s, String delim)
   {
       StringTokenizer st = new StringTokenizer(s, ",");
       Vector v = new Vector();
       while(st.hasMoreTokens())
           v.add(st.nextToken().trim());
       return v;
   }
   /***************************************************************************
    * isStringInVector -
    * @param s - String with delimiter
    * @param v - Vector
    * @return boolean
    **************************************************************************/

   public static boolean isStringInVector(String s, Vector v)
   {
       for(int i = 0; i < v.size(); i++)
       {
           String ts = (String)v.get(i);
           if(s.equals(ts))
               return true;
       }
       return false;
   }


   public static void main(String args[])
   {
       List<String> x = getDelimitedString("SE,USA,SV,Sweden", "*");
       List<String> strList = new ArrayList<String>();
       strList.add("1");
       strList.add("dfsfs");
       strList.add("fddfw4");
   }


   /**
    * isInputExistInDelimitedString method is used to find a string in a
    * COMMA seperated string.
    * Eg searchValue = "SE" ; delimitedString = "SE,USA,SV,Sweden" ; delimiter ="," returns TRUE
    * @param searchValue
    * @param delimitedString
    * @param delimiter
    * @return
    */
   public static boolean isInputExistInDelimitedString(String searchValue, String delimitedString, String delimiter) {
	    boolean isSearchValueExist =false;
	    List<String> delimitedInputList = getDelimitedString(delimitedString, delimiter);
	    if(delimitedInputList !=null && delimitedInputList.size()>0){
	        for(String delimitedInput:delimitedInputList){
	            if(searchValue.equals(delimitedInput)){
	                isSearchValueExist = true;
	                break;
	            }
	        }
	    }
	    return isSearchValueExist;
   }


    /**
	 *
	 * @param value
	 * @return
	 */
	public static String removeEscapeCharacter(String value) {
		// Use empty String if the value is null
		LOGGER.info("Value Before..." + value);
		if (value == null) {
			return "";
		}
		StringBuffer output = new StringBuffer();
		int stringSize = value.length();
		for (int i = 0; i < stringSize; i++) {
			char ch = value.charAt(i);
			if(ch != '\\'){
				output.append(ch);
			}
		}
		LOGGER.debug("Value After...:" + output.toString());
		return output.toString();
	}
	/**
	 *
	 * @param value
	 * @return
	 */
	public static String removeSingleCodes(String value) {
		String modifiedString = "";
		LOGGER.info("Value Before..." + value);
		// Use empty String if the value is null
		if (value == null) {
			return "";
		}
		StringBuffer output = new StringBuffer();
		int valueLenth = value.length() - 1;

		LOGGER.debug("valueLenth:"+valueLenth );
		for (int i = 0; i < value.length(); i++) {
			//LOGGER.info("i:"+i + "  valueLenth: "+valueLenth);
			char ch = value.charAt(i);
			//LOGGER.info("i: "+value.charAt(i));
			if(( i == 0 || i == valueLenth) && ch == '\''){
				//LOGGER.info("i: "+value.charAt(i) + "  valueLenth: "+valueLenth);
			}  else {
				output.append(ch);
				//LOGGER.info("i:"+value.charAt(i));
			}
		}
		LOGGER.debug("Value After...:" + output.toString());
		modifiedString = removeEscapeCharacter(output.toString());
		LOGGER.debug("Value After...:" + modifiedString);
		return modifiedString;
	}


	/**
	 * Checks whether passed-in character exist at the specified position of the input String
	 * @param input - String to scan for character
	 * @param targetChar - Character to check for
	 * @param index - Index to look for the character at
	 * @return
	 */
	public static boolean isCharAt(String input, char targetChar, int index) {
		LOGGER.info("Looking for character " + targetChar +"at position " + index
				+" in the string " + input);
		boolean result = false;
		if(!StringUtils.nullOrBlank(input)) {
			try {
			int fromIndex = input.length() -1;
			int findIndex = input.indexOf(targetChar, fromIndex);
			if(LOGGER.isDebugEnabled())
				LOGGER.debug("From index is " + fromIndex + " find " +
						"index is " + findIndex);
			if (findIndex >= 0) {
				result = true;
			}
			}catch(ArrayIndexOutOfBoundsException e) {
				LOGGER.error(e.getMessage(), e);
			}
		}
		return result;
	}

 public static String truncDecimal(String arg)
   {
	   String _arg ="";
	   int _index = 0;
	   if(!nullOrBlank(arg))
	   {
		   _index = arg.indexOf(".");
		   if(_index>0){

			   _arg = arg.substring(0, _index);
		   }else{
			   _arg =arg;
		   }
	   }
	   return _arg;
   }
 /**
  * Checks whether the passed-in String in arg1 has any excluded word or it is null or blank
  * @param arg1
  * @param excludedWords
  * @return true if the passed-in arg1 has any excluded word or it is null or blank
  */
 public static boolean nullOrBlank(String arg1, String[] excludedWords) {
	 boolean bResult = nullOrBlank(arg1);
	 if(!bResult) {
		bResult =  isExcluded(arg1, excludedWords);
	 }
	 return bResult;
 }
 /**
  * Checks whether or not the passed in arg1 is the same as one the String objects in excludedWords array
  * @param arg1
  * @param excludedWords
  * @return true if the
  */
 public static boolean isExcluded(String arg1, String[] excludedWords) {
	 if(LOGGER.isDebugEnabled())
		 LOGGER.debug("Entering containExcludedWords -- arg1 = " + arg1 + " Excluded words = " + excludedWords);
	 boolean bContain = false;
	 if(!StringUtils.nullOrBlank(arg1) && excludedWords != null && excludedWords.length > 0) {
		 for(int i = 0; i < excludedWords.length; i++) {
			 if(arg1.equals(excludedWords[i])) {
				 bContain = true;
				 if(LOGGER.isDebugEnabled()) {
					 LOGGER.debug("The string contains " + excludedWords[i]);
				 }
				 break;
			 }
		 }
	 }
	 return bContain;
 }

 public static String getFirstNodeValue(NodeList nodeList) {
	String nodeValue = "";
	StringBuffer varBuffer = new StringBuffer();
	Node node = (Node)nodeList.item(0);
	if(node != null) {
		/*if(node != null) {
			Node eleText = node.getFirstChild();
            if(eleText != null) {
            nodeValue = eleText.getNodeValue();
            }
		}*/
		NodeList childNodes = node.getChildNodes();
		for(int i=0;i<childNodes.getLength();i++){
			varBuffer.append(childNodes.item(i).getNodeValue().toString());
		}
	}
	nodeValue = varBuffer.toString();
	return nodeValue;


 }

 public static String getCDATA( String str ){
	 if( isEmpty(str)) return "";
	 return StringUtils.contains( str, "<") ? "<![CDATA[" + str + "]]>" : str;
 }

	/**
	 * returns list of strings based on the delimiters
	 */
	public static List<String> getDelimitedString(final String inputString, final String delimiter) {

		List<String> resultStringList = new ArrayList<String>();
		StringTokenizer token = new StringTokenizer(inputString, delimiter);
		while (token.hasMoreTokens()) {
			resultStringList.add(token.nextToken());
		}
		return resultStringList;
	}
	 /**
	  * getSingleQuoteString is used in DB layer where a list is to be converted  as
	  * @param valueList
	  * @return      */
	  public static String getSingleQuoteString(List<String> valueList) {
	  int inc = 1;
	  StringBuffer sqlQuery = new StringBuffer();
	  if (valueList != null && valueList.size() > 0) {
	  for (String value : valueList) {
	  sqlQuery.append("'");
	  sqlQuery.append(value);
	  sqlQuery.append("'");
	  if (inc++ < valueList.size()) {
	  sqlQuery.append(",");
	  }
	  }
	  }
	  return sqlQuery.toString();
	  }
}
