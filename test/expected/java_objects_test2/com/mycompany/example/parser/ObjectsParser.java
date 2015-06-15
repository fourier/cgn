/**
 * Copyright (c) 2015 by My Company
 * This file and its contents are Confidential.
 */
package com.mycompany.example.parser;

import java.text.ParseException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.Date;
import java.util.Map;
import java.util.HashMap;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonToken;
import java.io.IOException;

/**
 * Generated from java_objects_test2.xml on 15/6/2015
 */
public class ObjectsParser {

    /**
     * List of regular expressions used in parsing date/time for java.util.Date
     * time class
     */
    private static final Map<String, String> DATE_FORMAT_REGEXPS = new HashMap<String, String>();
    static {
        DATE_FORMAT_REGEXPS.put("^\\d{8}$", "yyyyMMdd");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}-\\d{1,2}-\\d{4}$", "dd-MM-yyyy");
        DATE_FORMAT_REGEXPS.put("^\\d{4}-\\d{1,2}-\\d{1,2}$", "yyyy-MM-dd");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}/\\d{1,2}/\\d{4}$", "MM/dd/yyyy");
        DATE_FORMAT_REGEXPS.put("^\\d{4}/\\d{1,2}/\\d{1,2}$", "yyyy/MM/dd");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{3}\\s\\d{4}$", "dd MMM yyyy");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{4,}\\s\\d{4}$", "dd MMMM yyyy");
        DATE_FORMAT_REGEXPS.put("^\\d{12}$", "yyyyMMddHHmm");
        DATE_FORMAT_REGEXPS.put("^\\d{8}\\s\\d{4}$", "yyyyMMdd HHmm");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}-\\d{1,2}-\\d{4}\\s\\d{1,2}:\\d{2}$", "dd-MM-yyyy HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{4}-\\d{1,2}-\\d{1,2}\\s\\d{1,2}:\\d{2}$", "yyyy-MM-dd HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}/\\d{1,2}/\\d{4}\\s\\d{1,2}:\\d{2}$", "MM/dd/yyyy HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{4}/\\d{1,2}/\\d{1,2}\\s\\d{1,2}:\\d{2}$", "yyyy/MM/dd HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{3}\\s\\d{4}\\s\\d{1,2}:\\d{2}$", "dd MMM yyyy HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{4,}\\s\\d{4}\\s\\d{1,2}:\\d{2}$", "dd MMMM yyyy HH:mm");
        DATE_FORMAT_REGEXPS.put("^\\d{14}$", "yyyyMMddHHmmss");
        DATE_FORMAT_REGEXPS.put("^\\d{8}\\s\\d{6}$", "yyyyMMdd HHmmss");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}-\\d{1,2}-\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "dd-MM-yyyy HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{4}-\\d{1,2}-\\d{1,2}\\s\\d{1,2}:\\d{2}:\\d{2}$", "yyyy-MM-dd HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}/\\d{1,2}/\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "MM/dd/yyyy HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{4}/\\d{1,2}/\\d{1,2}\\s\\d{1,2}:\\d{2}:\\d{2}$", "yyyy/MM/dd HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{3}\\s\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "dd MMM yyyy HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{1,2}\\s[a-z]{4,}\\s\\d{4}\\s\\d{1,2}:\\d{2}:\\d{2}$", "dd MMMM yyyy HH:mm:ss");
        DATE_FORMAT_REGEXPS.put("^\\d{4}-\\d{2}-\\d{2}t\\d{2}:\\d{2}:\\d{2}[+-]\\d{2}\\d{2}$", "yyyy-MM-dd'T'HH:mm:ssZ");
    }

    /**
     * Determine SimpleDateFormat pattern matching with the given date string. Returns null if
     * format is unknown. You can simply extend DateUtil with more formats if needed.
     * @param dateString The date string to determine the SimpleDateFormat pattern for.
     * @return The matching SimpleDateFormat pattern, or null if format is unknown.
     * @see SimpleDateFormat
     */
    private static String determineDateFormat(String dateString) {
        for (String regexp : DATE_FORMAT_REGEXPS.keySet()) {
            if (dateString.toLowerCase(Locale.US).matches(regexp)) {
                return DATE_FORMAT_REGEXPS.get(regexp);
            }
        }
        return null; /* Unknown format. */
    }
    /**
     * Parses the date string to the java.util.Date class using one of
     * formats from DATE_FORMAT_REGEXPS mapping
     * @param dateString the string containing the date/time to parse
     * @return java.util.Date object with the parsed date/time
     */
    public static Date parseDate(String dateString) throws IOException {
        String dateFormat = determineDateFormat(dateString);
        final DateFormat fmt = dateFormat != null ? new SimpleDateFormat(dateFormat, Locale.US) : SimpleDateFormat.getDateTimeInstance();
        Date result = null;
        try {
            result = fmt.parse(dateString);
        } catch (ParseException e) {
            throw new IOException("Unable to parse date: ".concat(dateString));
        }
        return result;
    }

    /**
     * Parses the date/time string into the Joda DateTime object.
     * @param dateString the string containing the date/time to parse
     * @return org.joda.time.DateTime object with the parsed date/time
     */
    public static org.joda.time.DateTime parseISODate(String dateString) throws IOException {
        org.joda.time.DateTime date = null;
        try {
           date = org.joda.time.format.ISODateTimeFormat.dateTimeParser().parseDateTime(dateString);
        } catch (UnsupportedOperationException e) {
            throw new IOException("Unable to parse date: ".concat(dateString));
        } catch (IllegalArgumentException e) {
            throw new IOException("Unable to parse date: ".concat(dateString));
        }
        return date;
    }

    public static com.mycompany.messages.Conversation parse(JsonParser parser, com.mycompany.messages.Conversation.Builder builder) throws IOException {
        /* object should start with the START_OBJECT token */
        if (parser.getCurrentToken() != JsonToken.START_OBJECT) throw new IOException("Json node for com.mycompany.messages.Conversation is not a Json Object");

        /* loop through all fields of the object */
        while(parser.nextValue() != JsonToken.END_OBJECT) {
            if (!parser.hasCurrentToken()) throw new IOException("Malformed JSON");
            final String currentName = parser.getCurrentName();

            if ("title".equals(currentName)) /* parse "title" of type String */ {
                /* type verification, either NULL or JsonToken.VALUE_STRING */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversation::title is not of type string");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    builder.setTitle(parser.getText());
                }
            }
            else if ("participant-ids".equals(currentName)) /* parse "participant-ids" of type java.util.ArrayList<Integer> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversation::participant-ids is not of type [int]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<Integer> array = new java.util.ArrayList<Integer>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversation::participant-ids[i] is not of type int");
                        array.add(Integer.valueOf(parser.getValueAsInt()));
                    }
                    /* call the setter and set field value */
                    builder.setParticipantIds(array);
                }
            }
            else if ("messages".equals(currentName)) /* parse "messages" of type java.util.ArrayList<String> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversation::messages is not of type [string]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<String> array = new java.util.ArrayList<String>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversation::messages[i] is not of type string");
                        array.add(parser.getText());
                    }
                    /* call the setter and set field value */
                    builder.setMessages(array);
                }
            }
            else {
                /* unknown element. Call skipChildren() if the element is an array or object */
                parser.skipChildren();
            }
        }

        return builder.create();
    }

    public static com.mycompany.messages.Conversations parse(JsonParser parser, com.mycompany.messages.Conversations conversations) throws IOException {
        /* object should start with the START_OBJECT token */
        if (parser.getCurrentToken() != JsonToken.START_OBJECT) throw new IOException("Json node for com.mycompany.messages.Conversations is not a Json Object");

        /* loop through all fields of the object */
        while(parser.nextValue() != JsonToken.END_OBJECT) {
            if (!parser.hasCurrentToken()) throw new IOException("Malformed JSON");
            final String currentName = parser.getCurrentName();

            if ("date".equals(currentName)) /* parse "date" of type org.joda.time.DateTime */ {
                /* type verification, either NULL or JsonToken.VALUE_STRING */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversations::date is not of type date");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    conversations.setDate(parseISODate(parser.getText()));
                }
            }
            else if ("conversations".equals(currentName)) /* parse "conversations" of type java.util.ArrayList<com.mycompany.messages.Conversation> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversations::conversations is not of type [com.mycompany.messages.Conversation]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<com.mycompany.messages.Conversation> array = new java.util.ArrayList<com.mycompany.messages.Conversation>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.START_OBJECT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversations::conversations[i] is not of type com.mycompany.messages.Conversation");
                        array.add(ObjectsParser.parse(parser, new com.mycompany.messages.Conversation.Builder()));
                    }
                    /* call the setter and set field value */
                    conversations.setConversations(array);
                }
            }
            else if ("company".equals(currentName)) /* parse "company" of type com.mycompany.protocol.Company */ {
                /* type verification, either NULL or JsonToken.START_OBJECT */
                if (!(parser.getCurrentToken() == JsonToken.START_OBJECT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversations::company is not of type com.mycompany.protocol.Company");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    conversations.setCompany(null);
                }
            }
            else if ("joda-dates".equals(currentName)) /* parse "joda-dates" of type java.util.ArrayList<org.joda.time.DateTime> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversations::joda-dates is not of type [date]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<org.joda.time.DateTime> array = new java.util.ArrayList<org.joda.time.DateTime>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversations::joda-dates[i] is not of type date");
                        array.add(parseISODate(parser.getText()));
                    }
                    /* call the setter and set field value */
                    conversations.setJodaDates(array);
                }
            }
            else if ("normal-dates".equals(currentName)) /* parse "normal-dates" of type java.util.ArrayList<java.util.Date> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversations::normal-dates is not of type [date]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<java.util.Date> array = new java.util.ArrayList<java.util.Date>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.Conversations::normal-dates[i] is not of type date");
                        array.add(parseDate(parser.getText()));
                    }
                    /* call the setter and set field value */
                    conversations.setNormalDates(array);
                }
            }
            else {
                /* unknown element. Call skipChildren() if the element is an array or object */
                parser.skipChildren();
            }
        }

        return conversations;
    }

    public static com.mycompany.messages.EntryNotIsSet parse(JsonParser parser, com.mycompany.messages.EntryNotIsSet entryNotIsSet) throws IOException {
        /* object should start with the START_OBJECT token */
        if (parser.getCurrentToken() != JsonToken.START_OBJECT) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet is not a Json Object");

        /* loop through all fields of the object */
        while(parser.nextValue() != JsonToken.END_OBJECT) {
            if (!parser.hasCurrentToken()) throw new IOException("Malformed JSON");
            final String currentName = parser.getCurrentName();

            if ("date".equals(currentName)) /* parse "date" of type java.util.Date */ {
                /* type verification, either NULL or JsonToken.VALUE_STRING */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::date is not of type date");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryNotIsSet.setDate(parseDate(parser.getText()));
                }
            }
            else if ("dates".equals(currentName)) /* parse "dates" of type java.util.ArrayList<java.util.Date> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::dates is not of type [date]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<java.util.Date> array = new java.util.ArrayList<java.util.Date>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::dates[i] is not of type date");
                        array.add(parseDate(parser.getText()));
                    }
                    /* call the setter and set field value */
                    entryNotIsSet.setDates(array);
                }
            }
            else if ("doubleValue".equals(currentName)) /* parse "doubleValue" of type double */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_FLOAT || JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_FLOAT || parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::doubleValue is not of type double");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryNotIsSet.setDoubleValue(parser.getValueAsDouble());
                }
            }
            else if ("stringValue".equals(currentName)) /* parse "stringValue" of type String */ {
                /* type verification, either NULL or JsonToken.VALUE_STRING */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::stringValue is not of type string");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryNotIsSet.setStringValue(parser.getText());
                }
            }
            else if ("boolValue".equals(currentName)) /* parse "boolValue" of type boolean */ {
                /* type verification, either NULL or JsonToken.VALUE_FALSE || JsonToken.VALUE_TRUE */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_FALSE || parser.getCurrentToken() == JsonToken.VALUE_TRUE || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::boolValue is not of type boolean");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryNotIsSet.setBoolValue(parser.getValueAsBoolean());
                }
            }
            else if ("intValue".equals(currentName)) /* parse "intValue" of type int */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::intValue is not of type int");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryNotIsSet.setIntValue(parser.getValueAsInt());
                }
            }
            else if ("longValue".equals(currentName)) /* parse "longValue" of type long */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::longValue is not of type long");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryNotIsSet.setLongValue(parser.getValueAsLong());
                }
            }
            else if ("byteValue".equals(currentName)) /* parse "byteValue" of type byte */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::byteValue is not of type byte");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryNotIsSet.setByteValue((byte)parser.getValueAsInt());
                }
            }
            else if ("longArray".equals(currentName)) /* parse "longArray" of type java.util.ArrayList<Long> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::longArray is not of type [long]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<Long> array = new java.util.ArrayList<Long>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::longArray[i] is not of type long");
                        array.add(Long.valueOf(parser.getValueAsLong()));
                    }
                    /* call the setter and set field value */
                    entryNotIsSet.setLongArray(array);
                }
            }
            else if ("lat".equals(currentName)) /* parse "lat" of type double */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_FLOAT || JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_FLOAT || parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::lat is not of type double");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryNotIsSet.setLat(parser.getValueAsDouble());
                }
            }
            else if ("long".equals(currentName)) /* parse "long" of type double */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_FLOAT || JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_FLOAT || parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryNotIsSet::long is not of type double");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryNotIsSet.setLong(parser.getValueAsDouble());
                }
            }
            else {
                /* unknown element. Call skipChildren() if the element is an array or object */
                parser.skipChildren();
            }
        }

        return entryNotIsSet;
    }

    public static com.mycompany.messages.EntryIsSet parse(JsonParser parser, com.mycompany.messages.EntryIsSet entryIsSet) throws IOException {
        /* object should start with the START_OBJECT token */
        if (parser.getCurrentToken() != JsonToken.START_OBJECT) throw new IOException("Json node for com.mycompany.messages.EntryIsSet is not a Json Object");

        /* loop through all fields of the object */
        while(parser.nextValue() != JsonToken.END_OBJECT) {
            if (!parser.hasCurrentToken()) throw new IOException("Malformed JSON");
            final String currentName = parser.getCurrentName();

            if ("date".equals(currentName)) /* parse "date" of type java.util.Date */ {
                /* type verification, either NULL or JsonToken.VALUE_STRING */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::date is not of type date");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryIsSet.setDate(parseDate(parser.getText()));
                }
            }
            else if ("dates".equals(currentName)) /* parse "dates" of type java.util.ArrayList<java.util.Date> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::dates is not of type [date]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<java.util.Date> array = new java.util.ArrayList<java.util.Date>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::dates[i] is not of type date");
                        array.add(parseDate(parser.getText()));
                    }
                    /* call the setter and set field value */
                    entryIsSet.setDates(array);
                }
            }
            else if ("doubleValue".equals(currentName)) /* parse "doubleValue" of type double */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_FLOAT || JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_FLOAT || parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::doubleValue is not of type double");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryIsSet.setDoubleValue(parser.getValueAsDouble());
                }
            }
            else if ("stringValue".equals(currentName)) /* parse "stringValue" of type String */ {
                /* type verification, either NULL or JsonToken.VALUE_STRING */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::stringValue is not of type string");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryIsSet.setStringValue(parser.getText());
                }
            }
            else if ("boolValue".equals(currentName)) /* parse "boolValue" of type boolean */ {
                /* type verification, either NULL or JsonToken.VALUE_FALSE || JsonToken.VALUE_TRUE */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_FALSE || parser.getCurrentToken() == JsonToken.VALUE_TRUE || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::boolValue is not of type boolean");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryIsSet.setBoolValue(parser.getValueAsBoolean());
                }
            }
            else if ("intValue".equals(currentName)) /* parse "intValue" of type int */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::intValue is not of type int");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryIsSet.setIntValue(parser.getValueAsInt());
                }
            }
            else if ("longValue".equals(currentName)) /* parse "longValue" of type long */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::longValue is not of type long");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryIsSet.setLongValue(parser.getValueAsLong());
                }
            }
            else if ("byteValue".equals(currentName)) /* parse "byteValue" of type byte */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::byteValue is not of type byte");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryIsSet.setByteValue((byte)parser.getValueAsInt());
                }
            }
            else if ("longArray".equals(currentName)) /* parse "longArray" of type java.util.ArrayList<Long> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::longArray is not of type [long]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<Long> array = new java.util.ArrayList<Long>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::longArray[i] is not of type long");
                        array.add(Long.valueOf(parser.getValueAsLong()));
                    }
                    /* call the setter and set field value */
                    entryIsSet.setLongArray(array);
                }
            }
            else if ("lat".equals(currentName)) /* parse "lat" of type double */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_FLOAT || JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_FLOAT || parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::lat is not of type double");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryIsSet.setLat(parser.getValueAsDouble());
                }
            }
            else if ("long".equals(currentName)) /* parse "long" of type double */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_FLOAT || JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_FLOAT || parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.messages.EntryIsSet::long is not of type double");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    entryIsSet.setLong(parser.getValueAsDouble());
                }
            }
            else {
                /* unknown element. Call skipChildren() if the element is an array or object */
                parser.skipChildren();
            }
        }

        return entryIsSet;
    }

    public static com.mycompany.example.UserData parse(JsonParser parser, com.mycompany.example.UserData userData) throws IOException {
        /* object should start with the START_OBJECT token */
        if (parser.getCurrentToken() != JsonToken.START_OBJECT) throw new IOException("Json node for com.mycompany.example.UserData is not a Json Object");

        /* loop through all fields of the object */
        while(parser.nextValue() != JsonToken.END_OBJECT) {
            if (!parser.hasCurrentToken()) throw new IOException("Malformed JSON");
            final String currentName = parser.getCurrentName();

            if ("name".equals(currentName)) /* parse "name" of type String */ {
                /* type verification, either NULL or JsonToken.VALUE_STRING */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.example.UserData::name is not of type string");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    userData.setName(parser.getText());
                }
            }
            else if ("occupation".equals(currentName)) /* parse "occupation" of type String */ {
                /* type verification, either NULL or JsonToken.VALUE_STRING */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.example.UserData::occupation is not of type string");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    userData.setOccupation(parser.getText());
                }
            }
            else if ("age".equals(currentName)) /* parse "age" of type int */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.example.UserData::age is not of type int");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    userData.setAge(parser.getValueAsInt());
                }
            }
            else if ("visits".equals(currentName)) /* parse "visits" of type java.util.ArrayList<java.util.Date> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.example.UserData::visits is not of type [date]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<java.util.Date> array = new java.util.ArrayList<java.util.Date>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.example.UserData::visits[i] is not of type date");
                        array.add(parseDate(parser.getText()));
                    }
                    /* call the setter and set field value */
                    userData.setVisits(array);
                }
            }
            else {
                /* unknown element. Call skipChildren() if the element is an array or object */
                parser.skipChildren();
            }
        }

        return userData;
    }

}
