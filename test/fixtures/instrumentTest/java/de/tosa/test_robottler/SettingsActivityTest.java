package de.tosa.test_robottler;

import android.content.Intent;
import android.test.ActivityInstrumentationTestCase2;

import de.tosa.test_robottler.SettingsActivity;
import de.tosa.test_robottler.R;

import com.squareup.spoon.Spoon;

public class SettingsActivityTest extends ActivityInstrumentationTestCase2<SettingsActivity> {

    public SettingsActivityTest() {
        super(SettingsActivity.class);
    }

    @Override
    protected void setUp() throws Exception {
        super.setUp();
        getActivity();
    }

    @Override
    protected void tearDown() throws Exception {
        super.tearDown();
    }

    public void testView() {
        Spoon.screenshot(getActivity(), "initial_state");
    }
}
