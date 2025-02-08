package com.example.nb_utils

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.test.Test
import org.mockito.Mockito

internal class NbUtilsPluginTest {

    @Test
    fun onMethodCall_getPlatformVersion_returnsExpectedValue() {
        val plugin = NbUtilsPlugin()

        // Creating MethodCall with the proper method name
        val call = MethodCall("getPlatformVersion", null)
        
        // Mocking the result of the MethodChannel
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        
        // Making the method call
        plugin.onMethodCall(call, mockResult)

        // Verifying that the correct response is passed back to the MethodChannel result
        Mockito.verify(mockResult).success("Android " + android.os.Build.VERSION.RELEASE)
    }
}
