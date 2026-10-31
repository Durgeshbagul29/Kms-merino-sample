import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;

  const CustomButton({super.key, required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {

    return GFButton(size: GFSize.LARGE,
      color: Theme.of(context).primaryColor,
      text: buttonText,
      blockButton: true,
      onPressed: () => onPressed,
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:kms/utils/app_dimensions.dart';

// class CustomButton extends StatelessWidget {
//   final Function onPressed;
//   final String buttonText;
//   // final bool transparent;
//   // final EdgeInsets margin;
//   // final double height;
//   // final double width;
//   // final double fontSize;
//   // final double radius;
//   // final IconData? icon;

//   CustomButton({Key? key, required this.onPressed, required this.buttonText}) : super(key: key);
//   // CustomButton({required this.onPressed, required this.buttonText, this.transparent = false, this.margin, this.width, this.height,
//   //   this.fontSize, this.radius = 5, this.icon});

//   @override
//   Widget build(BuildContext context) {
//     final ButtonStyle _flatButtonStyle = TextButton.styleFrom(
//       backgroundColor: Theme.of(context).primaryColor,
//       minimumSize: Size(Dimensions.WEB_MAX_WIDTH, 50),
//       padding: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5),
//       ),
//     );

//     return
//       // Padding(
//       // padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.only(left: Dimensions.PADDING_SIZE_OVER_OVER_LARGE, right: Dimensions.PADDING_SIZE_OVER_OVER_LARGE,) : EdgeInsets.all(0),
//       // child:
//       Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Padding(
//       padding: EdgeInsets.all(0),
//       // padding: margin == null ? EdgeInsets.all(0) : ResponsiveHelper.isDesktop(context) ? EdgeInsets.only(left: 100, right: 100) : margin,
//       child: TextButton(
//         onPressed: () => onPressed,
//         style: _flatButtonStyle,
//         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           // icon != null ? Padding(
//           //   padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//           //   child: Icon(icon, color: Theme.of(context).cardColor),
//           // ) : SizedBox(),
//           Text(buttonText, textAlign: TextAlign.center, 
//           style: TextStyle(
//             color: Theme.of(context).cardColor,
//             fontSize: Dimensions.fontSizeLarge,
//           )
//           ),
//         ]),
//       ),
//     // )
//       )));
//   }
// }
