package <%= package %>;

import android.content.Intent;
import android.test.ActivityInstrumentationTestCase2;

import <%= package %>.<%= activity %>;
import <%= app_package %>.R;

import com.squareup.spoon.Spoon;

public class <%= activity %>Test extends ActivityInstrumentationTestCase2<<%= activity %>> {

    public <%= activity %>Test() {
        super(<%= activity %>.class);
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

    public void test<%= activity %>View() {
        Spoon.screenshot(getActivity(), "initial_state");
    }
}
