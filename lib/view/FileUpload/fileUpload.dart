import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as ui;
class FileUpload extends StatefulWidget {
  const FileUpload({super.key});

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {


  File? image;
  bool isLoading  = false;
  int width = 0;
  int height = 0;
  Uint8List? watermarkedImgBytes;
  pickImage()
  async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ["jpg",'png','jpeg'],
      allowCompression: true,
    );
    if(result != null)
      {
        setState(() {
          isLoading = true;
        });
        image = File(result.files.single.path!);
        var bytes = await image!.readAsBytes();
        var decodedImage = await decodeImageFromList(bytes);
        width = decodedImage.width;
        height = decodedImage.height;
        ui.Image? originalImage = await ui.decodeImage(bytes);
        String data = "KugelBlitz\nKeshav\nTime and date";
        ui.drawString(originalImage!,ui.arial_24,(width *0.05).toInt(),(height*0.90).toInt(),data);
        var temp = await getTemporaryDirectory();
        await File("${temp.path}/image_from_data.png").writeAsBytes(ui.encodePng(originalImage));
        image = File("${temp.path}/image_from_data.png");

        setState(() {
          //image = File.fromRawPath(watermarkedImgBytes);
          isLoading = false;
        });
      }
  }

  addWaterMark(String text,File file)
  async{

    var bytes = await file.readAsBytes();
    print(bytes);
    print("Called");
    print("Ended");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap:(){
                    pickImage();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Text("Select Files",style: TextStyle(color: Colors.white),),
                  ),
                ),
                const SizedBox(height: 10,),
                isLoading ? const Center(child: CircularProgressIndicator(),) :
                image != null ? Container(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [

                      Image.file(image!),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              image = null;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(CupertinoIcons.xmark),
                          ),
                        ),
                      ),
                    ],
                  ),
                ) : Text("No Data") ,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
