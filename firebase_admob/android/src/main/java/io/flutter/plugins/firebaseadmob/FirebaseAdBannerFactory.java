package io.flutter.plugins.firebaseadmob;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * Firebase banner广告工厂
 *
 * @version 1.0
 * <p>
 * Created by mac_Leo on 2019-10-16.
 */
public class FirebaseAdBannerFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;

    FirebaseAdBannerFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new AdBannerView(context, messenger, id, params);
    }
}
