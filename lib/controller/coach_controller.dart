

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sonalysis/model/response/UploadVideoResponseModel.dart';
import 'package:sonalysis/services/api.dart';
import 'package:sonalysis/services/network_service.dart';
import 'package:path/path.dart' as p;

class CoachController {

  var logger = Logger();

  //doVideoUpload
  Future<UploadVideoResponseModel> doVideoUpload(BuildContext context, String videoURL, String pastedVideoURL, File? file) async {

    var request = {
      "filename": videoURL == null ? pastedVideoURL : videoURL,
      "originalFilename": file != null ? p.basenameWithoutExtension(file.path) : "file upload",
    };


    Map<String, dynamic> userSignup = await callAPI(
        url: baseUrl + "upload/update-link",
        requestType: RequestType.POST,
        payload: request,
        context: context);


    return UploadVideoResponseModel.fromJson(userSignup);
  }



}