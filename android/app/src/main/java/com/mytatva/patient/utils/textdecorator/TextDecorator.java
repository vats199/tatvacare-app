package com.mytatva.patient.utils.textdecorator;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.BlurMaskFilter;
import android.graphics.Color;
import android.graphics.EmbossMaskFilter;
import android.graphics.Typeface;
import android.text.Layout;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.method.LinkMovementMethod;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.AlignmentSpan;
import android.text.style.BackgroundColorSpan;
import android.text.style.BulletSpan;
import android.text.style.ClickableSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.ImageSpan;
import android.text.style.MaskFilterSpan;
import android.text.style.QuoteSpan;
import android.text.style.RelativeSizeSpan;
import android.text.style.ScaleXSpan;
import android.text.style.StrikethroughSpan;
import android.text.style.StyleSpan;
import android.text.style.SubscriptSpan;
import android.text.style.SuperscriptSpan;
import android.text.style.TextAppearanceSpan;
import android.text.style.TypefaceSpan;
import android.text.style.UnderlineSpan;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.ColorInt;
import androidx.annotation.ColorRes;
import androidx.annotation.DrawableRes;
import androidx.annotation.FontRes;
import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.core.content.res.ResourcesCompat;

import com.google.android.material.textfield.TextInputLayout;

import java.util.List;
import java.util.Map;


public class TextDecorator {
    private TextView textView;
    private String content;
    private SpannableString decoratedContent;
    private int flags;

    private TextDecorator(TextView textView, String content) {
        this.textView = textView;
        this.content = content;
        this.decoratedContent = new SpannableString(content);
        this.flags = Spanned.SPAN_EXCLUSIVE_EXCLUSIVE;
    }

    public static TextDecorator decorate(TextView textView, String content) {
        return new TextDecorator(textView, content);
    }

    public TextDecorator setFlags(final int flags) {
        this.flags = flags;

        return this;
    }

    public TextDecorator underline(final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new UnderlineSpan(), start, end, flags);

        return this;
    }

    public TextDecorator underline(final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new UnderlineSpan(), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setTextColor(@ColorRes final int resColorId, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new ForegroundColorSpan(ContextCompat.getColor(textView.getContext(), resColorId)), start, end,
                flags);

        return this;
    }

    public TextDecorator setTextColor(@ColorRes final int resColorId, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new ForegroundColorSpan(ContextCompat.getColor(textView.getContext(), resColorId)), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setTextColorOfLast(@ColorRes final int resColorId, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.lastIndexOf(text);
                decoratedContent.setSpan(new ForegroundColorSpan(ContextCompat.getColor(textView.getContext(), resColorId)), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setBackgroundColor(@ColorRes final int colorResId, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new BackgroundColorSpan(ContextCompat.getColor(textView.getContext(), colorResId)), start, end, 0);

        return this;
    }

    public TextDecorator setBackgroundColor(@ColorRes final int colorResId, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new BackgroundColorSpan(ContextCompat.getColor(textView.getContext(), colorResId)), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator insertBullet(final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new BulletSpan(), start, end, flags);

        return this;
    }

    public TextDecorator insertBullet(final int gapWidth, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new BulletSpan(gapWidth), start, end, flags);

        return this;
    }

    public TextDecorator insertBullet(final int gapWidth, @ColorRes final int colorResId, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new BulletSpan(gapWidth, ContextCompat.getColor(textView.getContext(), colorResId)), start, end,
                flags);

        return this;
    }

    public TextDecorator makeTextClickable(final View.OnClickListener listener, final int start, final int end, final boolean underlineText) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new ClickableSpan() {
                                     @Override
                                     public void onClick(View view) {
                                         listener.onClick(view);
                                     }

                                     @Override
                                     public void updateDrawState(TextPaint ds) {
                                         super.updateDrawState(ds);
                                         ds.setUnderlineText(underlineText);
                                     }
                                 }

                , start, end, flags);
        textView.setMovementMethod(LinkMovementMethod.getInstance());

        return this;
    }


    public TextDecorator makeTextClickable(final View.OnClickListener listener, final boolean underlineText, final String... texts) {
        int index;

        for (final String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);

                decoratedContent.setSpan(new ClickableSpan() {
                    @Override
                    public void onClick(View view) {
                        listener.onClick(view);
                    }

                    @Override
                    public void updateDrawState(TextPaint ds) {
                        super.updateDrawState(ds);
                        ds.setColor(Color.WHITE);
                        ds.setUnderlineText(underlineText);
                    }
                }, index, index + text.length(), flags);
            }
        }

        textView.setMovementMethod(LinkMovementMethod.getInstance());

        return this;
    }

    public TextDecorator makeTextClickableWithSecondaryColor(@ColorInt int color, final View.OnClickListener listener, final boolean underlineText, final String... texts) {
        int index;

        for (final String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);

                decoratedContent.setSpan(new ClickableSpan() {
                    @Override
                    public void onClick(View view) {
                        listener.onClick(view);
                    }

                    @Override
                    public void updateDrawState(TextPaint ds) {
                        super.updateDrawState(ds);
                        ds.setColor(color);
                        ds.setUnderlineText(underlineText);
                    }
                }, index, index + text.length(), flags);
            }
        }

        textView.setMovementMethod(LinkMovementMethod.getInstance());

        return this;
    }

    public TextDecorator makeTextClickableWithBlueColor(final View.OnClickListener listener, final boolean underlineText, final String... texts) {
        int index;

        for (final String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);

                decoratedContent.setSpan(new ClickableSpan() {
                    @Override
                    public void onClick(View view) {
                        listener.onClick(view);
                    }

                    @Override
                    public void updateDrawState(TextPaint ds) {
                        super.updateDrawState(ds);
                        ds.setColor(Color.BLUE);
                        ds.setUnderlineText(underlineText);
                    }
                }, index, index + text.length(), flags);
            }
        }

        textView.setMovementMethod(LinkMovementMethod.getInstance());

        return this;
    }

    public TextDecorator makeTextClickable(final ClickableSpan clickableSpan, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(clickableSpan, start, end, flags);
        textView.setMovementMethod(LinkMovementMethod.getInstance());

        return this;
    }

    public TextDecorator makeTextClickable(final View.OnClickListener listener, final int color, final boolean underlineText, final Map<String, String> texts) {
        int index;
        int lastIndex = 0;

        for (final Map.Entry<String, String> text : texts.entrySet()) {
            if (content.substring(lastIndex).contains(text.getValue())) {
                index = content.indexOf(text.getValue(), lastIndex);

                decoratedContent.setSpan(new ClickableSpan() {
                    @Override
                    public void onClick(View view) {
                        listener.onClick(view);
                    }

                    @Override
                    public void updateDrawState(TextPaint ds) {
                        super.updateDrawState(ds);
                        ds.setUnderlineText(underlineText);
                        ds.setColor(color);
                    }
                }, index, index + text.getValue().length(), flags);

                lastIndex = index + text.getValue().length();
            }
        }

        textView.setMovementMethod(LinkMovementMethod.getInstance());

        return this;
    }

    public TextDecorator makeTextClickable(final List<String> texts, final boolean underlineText, final View.OnClickListener listener) {
        int index;

        for (final String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);

                decoratedContent.setSpan(new ClickableSpan() {
                    @Override
                    public void onClick(View view) {
                        listener.onClick(view);
                    }

                    @Override
                    public void updateDrawState(TextPaint ds) {
                        super.updateDrawState(ds);
                        ds.setUnderlineText(underlineText);
                    }
                }, index, index + text.length(), flags);
            }
        }
        return this;
    }

    public TextDecorator makeTextClickable(final ClickableSpan clickableSpan, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(clickableSpan, index, index + text.length(), flags);
            }
        }

        textView.setMovementMethod(LinkMovementMethod.getInstance());

        return this;
    }

    public TextDecorator insertImage(@DrawableRes final int resId, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new ImageSpan(textView.getContext(), resId), start, end, flags);

        return this;
    }

    public TextDecorator quote(final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new QuoteSpan(), start, end, flags);

        return this;
    }

    public TextDecorator quote(final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new QuoteSpan(), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator quote(@ColorRes final int colorResId, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new QuoteSpan(ContextCompat.getColor(textView.getContext(), colorResId)), start, end,
                flags);

        return this;
    }

    public TextDecorator quote(@ColorRes final int colorResId, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new QuoteSpan(ContextCompat.getColor(textView.getContext(), colorResId)), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator strikethrough(final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new StrikethroughSpan(), start, end, flags);

        return this;
    }

    public TextDecorator strikethrough(final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new StrikethroughSpan(), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setTextStyle(final int style, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new StyleSpan(style), start, end, flags);

        return this;
    }

    public TextDecorator setTextStyle(final int style, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new StyleSpan(style), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator alignText(final Layout.Alignment alignment, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new AlignmentSpan.Standard(alignment), start, end, flags);

        return this;
    }

    public TextDecorator alignText(final Layout.Alignment alignment, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new AlignmentSpan.Standard(alignment), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setSubscript(final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new SubscriptSpan(), start, end, flags);

        return this;
    }

    public TextDecorator setSubscript(final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new SubscriptSpan(), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setSuperscript(final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new SuperscriptSpan(), start, end, flags);

        return this;
    }

    public TextDecorator setSuperscript(final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new SuperscriptSpan(), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setTypeface(final String family, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new TypefaceSpan(family), start, end, flags);

        return this;
    }

    public TextDecorator setTypeface(final String family, @NonNull final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new TypefaceSpan(family), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setTextAppearance(final int appearance, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new TextAppearanceSpan(textView.getContext(), appearance), start, end,
                flags);

        return this;
    }

    public TextDecorator setTextAppearance(final int appearance, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new TextAppearanceSpan(textView.getContext(), appearance), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setTextAppearance(final int appearance, final int colorList, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new TextAppearanceSpan(textView.getContext(), appearance, colorList), start, end,
                flags);

        return this;
    }

    public TextDecorator setTextAppearance(final int appearance, final int colorList, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new TextAppearanceSpan(textView.getContext(), appearance, colorList), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setTextAppearance(String family, int style, int size, ColorStateList color, ColorStateList linkColor, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new TextAppearanceSpan(family, style, size, color, linkColor), start, end,
                flags);

        return this;
    }

    public TextDecorator setTextAppearance(String family, int style, int size, ColorStateList color, ColorStateList linkColor, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new TextAppearanceSpan(family, style, size, color, linkColor), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setAbsoluteSize(final int size, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new AbsoluteSizeSpan(size), start, end, flags);

        return this;
    }

    public TextDecorator setAbsoluteSize(final int size, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new AbsoluteSizeSpan(size), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setAbsoluteSize(final int size, final boolean dip, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new AbsoluteSizeSpan(size, dip), start, end, flags);

        return this;
    }

    public TextDecorator setAbsoluteSize(final int size, final boolean dip, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new AbsoluteSizeSpan(size, dip), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator setRelativeSize(final float proportion, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new RelativeSizeSpan(proportion), start, end, flags);

        return this;
    }

    public TextDecorator setRelativeSize(final float proportion, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new RelativeSizeSpan(proportion), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator scaleX(final float proportion, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new ScaleXSpan(proportion), start, end, flags);

        return this;
    }

    public TextDecorator scaleX(final float proportion, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new ScaleXSpan(proportion), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator blur(final float radius, final BlurMaskFilter.Blur style, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new MaskFilterSpan(new BlurMaskFilter(radius, style)), start, end, flags);

        return this;
    }

    public TextDecorator blur(final float radius, final BlurMaskFilter.Blur style, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new MaskFilterSpan(new BlurMaskFilter(radius, style)), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public TextDecorator emboss(final float[] direction, final float ambient, final float specular, final float blurRadius, final int start, final int end) {
        checkIndexOutOfBoundsException(start, end);
        decoratedContent.setSpan(new MaskFilterSpan(new EmbossMaskFilter(direction, ambient, specular, blurRadius)), start, end,
                flags);

        return this;
    }

    public TextDecorator emboss(final float[] direction, final float ambient, final float specular, final float blurRadius, final String... texts) {
        int index;

        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(new MaskFilterSpan(new EmbossMaskFilter(direction, ambient, specular, blurRadius)), index, index + text.length(), flags);
            }
        }

        return this;
    }

    public void build() {
        textView.setText(decoratedContent, TextView.BufferType.SPANNABLE);
    }

    public SpannableString make() {
        return decoratedContent;
    }

    private void checkIndexOutOfBoundsException(final int start, final int end) {
        if (start < 0) {
            throw new IndexOutOfBoundsException("start is less than 0");
        } else if (end > content.length()) {
            throw new IndexOutOfBoundsException("end is greater than content length " + content.length());
        } else if (start > end) {
            throw new IndexOutOfBoundsException("start is greater than end");
        }
    }

    /* public Spannable getFontSpannable(Context context, String start, String end) {

        Typeface opensansRegular = ResourcesCompat.getFont(context
                , R.font.poppins_regular);
        Typeface opensansLight = ResourcesCompat.getFont(context
                , R.font.poppins_bold);


        int slength = start.length();

        String combine = start + end;
        Spannable spannable = new SpannableString(start + end);
        spannable.setSpan(new CustomTypefaceSpan("bold", opensansLight)
                , 0
                , slength
                , Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        spannable.setSpan(new CustomTypefaceSpan("bold", opensansRegular)
                , slength
                , combine.length()
                , Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        return spannable;
    }*/

    /*public Spannable getFontSpannable(Context context
            , String start
            , String end
            , @FontRes int fontOne
            , @FontRes int fontTwo) {

        Typeface opensansRegular = ResourcesCompat.getFont(context
                , fontOne);
        Typeface opensansLight = ResourcesCompat.getFont(context
                , fontTwo);


        int slength = start.length();

        String combine = start + end;
        Spannable spannable = new SpannableString(start + end);
        spannable.setSpan(new CustomTypefaceSpan("bold", opensansRegular)
                , 0
                , slength
                , Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        spannable.setSpan(new CustomTypefaceSpan("bold", opensansLight)
                , slength
                , combine.length()
                , Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        return spannable;
    }*/

    public TextDecorator setTypeFace(@FontRes int font, String... texts) {
        Typeface fontTypeface = ResourcesCompat.getFont(textView.getContext()
                , font);

        int index;

        CustomTypefaceSpan fontSpan = new CustomTypefaceSpan("regular", fontTypeface);
        for (String text : texts) {
            if (content.contains(text)) {
                index = content.indexOf(text);
                decoratedContent.setSpan(fontSpan, index, index + text.length(), flags);
            }
        }

        textView.setMovementMethod(LinkMovementMethod.getInstance());

        return this;
    }

    //Set fonts for textinputlayout
    public void setTypefaceForTextInputLayout(Context context, @FontRes int font, TextInputLayout textInputLayout) {
        Typeface face = ResourcesCompat.getFont(context, font);
        textInputLayout.setTypeface(face);
    }

    //Set fonts for textinputlayout
    public void setTypefaceForTextInputLayout(Context context, @FontRes int font, TextInputLayout... textInputLayout) {
        Typeface face = ResourcesCompat.getFont(context, font);
        for (TextInputLayout layout : textInputLayout) {
            layout.setTypeface(face);
        }
    }
}
