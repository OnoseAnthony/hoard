class OnboardingModel {
  final String imagePath;
  final String title;
  final String subtitle;

  OnboardingModel({this.imagePath, this.title, this.subtitle});

  static List<OnboardingModel> list = [
    OnboardingModel(
      imagePath: 'assets/images/kyc2.png',
      title: "Instant online loans",
      subtitle:
          "Lorem Ipsum donor ut wisi enim ad veniam no strus excertion isioma vecta ipsom nordor alexandra bebe du vec la hot",
    ),
    OnboardingModel(
      imagePath: 'assets/images/kyc3.png',
      title: "Service is fully automated",
      subtitle:
          "Lorem Ipsum donor sit amet cons duis autem vel eum in hendre in vul putate asta belarus de ruvarish de lacte be la ad",
    ),
    OnboardingModel(
      imagePath: 'assets/images/kyc3.png',
      title: "Apply from home",
      subtitle:
          "Lorem Ipsum donor sit amet cons duis autem vel eum in hendre in vul putate asta belarus de ruvarish de lacte be la ad",
    ),
    OnboardingModel(
      imagePath: 'assets/images/kyc2.png',
      title: "Getting started is easy!",
      subtitle:
          "Lorem Ipsum donor factor et du la eta rectum de ala vector ra et papercode and Lexah payment systems",
    ),
  ];
}
