import 'package:sonalysis/lang/strings.dart';

class OnboardingModel {
  String image;

  OnboardingModel({ this.image = ""});

  void setImage(String image) {
    this.image = image;
  }

  String getImage() {return image;}
}

List<OnboardingModel> getSlides() {
  List<OnboardingModel> slides =  <OnboardingModel>[];
  OnboardingModel onboardingModel = OnboardingModel(image: '');

  onboardingModel.setImage(ONBOARDING_SCREEN_01_IMAGE);
  slides.add(onboardingModel);
  onboardingModel = OnboardingModel(image: "");

  onboardingModel.setImage(ONBOARDING_SCREEN_02_IMAGE);
  slides.add(onboardingModel);
  onboardingModel = OnboardingModel(image: "");

  onboardingModel.setImage(ONBOARDING_SCREEN_03_IMAGE);
  slides.add(onboardingModel);
  onboardingModel = OnboardingModel();

  onboardingModel.setImage(ONBOARDING_SCREEN_04_IMAGE);
  slides.add(onboardingModel);
  onboardingModel = OnboardingModel();

  return slides;
}