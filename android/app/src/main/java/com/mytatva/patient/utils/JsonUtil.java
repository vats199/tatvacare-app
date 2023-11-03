package com.mytatva.patient.utils;

import com.google.gson.JsonObject;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

public class JsonUtil {
    public static JSONObject toJSON(String text) {
        JSONObject json;
        try {
            json = new JSONObject(text);
        } catch (JSONException e) {
            return null;
        }
        return json;
    }
}