package com.mytatva.patient.utils;

import org.json.JSONException;
import org.json.JSONObject;

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