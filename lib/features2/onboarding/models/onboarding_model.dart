import 'package:easy_localization/src/public_ext.dart';
import 'package:sonalysis/core/utils/images.dart';

class OnboardingModel {
  String image, header, subHeader;

  OnboardingModel({required this.image, required this.header, required this.subHeader});


  void setImage(String image) {
    this.image = image;
  }

  String getImage() {return image;}

  void setHeader(String header) {
      this.header = header;
    }

  String getHeader() {return header;}

  void setSubHeader(String subHeader) {
      this.subHeader = subHeader;
    }

  String getSubHeader() {return subHeader;}
}

List<OnboardingModel> getSlides() {
  List<OnboardingModel> slides =  <OnboardingModel>[];
  OnboardingModel onboardingModel = new OnboardingModel(image: '', subHeader: '', header: '');

  onboardingModel.setImage(AppAssets.ONBOARDING_SCREEN_01_IMAGE);
  onboardingModel.setHeader('onboarding_header1'.tr());
  onboardingModel.setSubHeader('onboarding_subheader1'.tr());
  slides.add(onboardingModel);
  onboardingModel = OnboardingModel(image: '', subHeader: '', header: '');

  onboardingModel.setImage(AppAssets.ONBOARDING_SCREEN_02_IMAGE);
  onboardingModel.setHeader('onboarding_header2'.tr());
  onboardingModel.setSubHeader('onboarding_subheader2'.tr());
  slides.add(onboardingModel);
  onboardingModel = OnboardingModel(image: '', subHeader: '', header: '');

  onboardingModel.setImage(AppAssets.ONBOARDING_SCREEN_03_IMAGE);
  onboardingModel.setHeader('onboarding_header3'.tr());
  onboardingModel.setSubHeader('onboarding_subheader3'.tr());
  slides.add(onboardingModel);
  onboardingModel = OnboardingModel(image: '', subHeader: '', header: '');

  return slides;
}