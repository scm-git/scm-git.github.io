# [王孝东的个人空间](https://scm-git.github.io/)
## QRCodeUtil
  ```java
package com.wxd.utils;

import com.google.zxing.*;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import javax.imageio.ImageIO;
import java.io.*;
import java.util.HashMap;
import java.util.Map;

public class QRCodeUtil {
    public static void main(String[] args) throws WriterException, IOException,
            NotFoundException {
        String qrCodeData = "Hello World!";
        String filePath = "QRCode.png";
        String charset = "UTF-8"; // or "ISO-8859-1"
        Map hintMap = new HashMap();
        hintMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);

        createQRCode(qrCodeData, filePath, charset, hintMap, 200, 200);
        System.out.println("QR Code image created successfully!");

        System.out.println("Data read from QR Code: "
                + readQRCode(filePath, charset, hintMap));

    }

    public static void createQRCode(String qrCodeData, String filePath,
                                    String charset, Map hintMap, int qrCodeheight, int qrCodewidth)
            throws WriterException, IOException {
        BitMatrix matrix = new MultiFormatWriter().encode(
                new String(qrCodeData.getBytes(charset), charset),
                BarcodeFormat.QR_CODE, qrCodewidth, qrCodeheight, hintMap);
        MatrixToImageWriter.writeToFile(matrix, filePath.substring(filePath
                .lastIndexOf('.') + 1), new File(filePath) {
        });
    }

    public static String readQRCode(String filePath, String charset, Map hintMap)
            throws FileNotFoundException, IOException, NotFoundException {
        BinaryBitmap binaryBitmap = new BinaryBitmap(new HybridBinarizer(
                new BufferedImageLuminanceSource(
                        ImageIO.read(new FileInputStream(filePath)))));
        Result qrCodeResult = new MultiFormatReader().decode(binaryBitmap,
                hintMap);
        return qrCodeResult.getText();
    }

    public static String readQRCode(InputStream inputStream)
            throws FileNotFoundException, IOException, NotFoundException {
        Map hintMap = new HashMap();
        hintMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
        BinaryBitmap binaryBitmap = new BinaryBitmap(new HybridBinarizer(
                new BufferedImageLuminanceSource(
                        ImageIO.read(inputStream))));
        Result qrCodeResult = new MultiFormatReader().decode(binaryBitmap,
                hintMap);
        return qrCodeResult.getText();
    }
}

  ```

## BarcodeUtil
  ```java
  public void testBarcode2() throws Exception {
        BarcodePDF417 barcode = new BarcodePDF417();

        barcode.setText("4902555131719");
        barcode.setAspectRatio(.25f);
        // Image image = barcode.createAwtImage(Color.BLACK, Color.WHITE);

        // return barcode.createAwtImage(Color.BLACK, Color.WHITE);

        // BarcodeEAN codeEAN = new BarcodeEAN();
        Barcode128 barcode128 = new Barcode128();
        barcode128.setBarHeight(200f);
        // codeEAN.setCodeType(codeEAN.SUPP5);
        barcode128.setCode("ZA4902555131719");
        String value = barcode128.getCode();
        System.out.println(value);       // I want to show this code on the picture
        barcode128.setAltText(value);
        Image image = barcode128.createAwtImage(Color.black, Color.white);


        BufferedImage bffImg
                        = new BufferedImage(image.getWidth(null),image.getHeight(null), BufferedImage.TYPE_3BYTE_BGR);
        Graphics graphics = bffImg.createGraphics();
        graphics.drawImage(image, 0, 0, null);

        ImageIO.write(bffImg, "png", new File("test.png"));
}
  ```