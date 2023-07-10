
import 'package:expense/utils/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: const Text('LiFi'),
        
          ),
        ],

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [

                Image.asset(
                  lifiIcon
                ),

                const SizedBox(height: 5,),

                const Text('Version: 1.0'),

                const SizedBox(height: 15,),


                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      height: 1.5
                    ),
                    text: 'Introducing LiFi, the ultimate tool for managing your personal finances and achieving your financial goals. With a range of powerful features and a commitment to financial education, LiFi empowers you to take control of your money like never before.',
          
                    children: [
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.5
                        ),
                        text: '\n\nTrack Your Finances:',
                      ),
          
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.5
                        ),
                        text: '  Effortlessly record and categorize your expenses and income on the go. Our user-friendly interface makes it easy to stay organized and gain a clear overview of your spending habits. By tracking every transaction, you\'ll have a complete picture of your financial health.',
                      ),
          
          
          
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.5
                        ),
                        text: '\n\nSet and Achieve Goals:',
                      ),
          
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.5
                        ),
                        text: '  Define your savings goals and let LiFi guide you toward making them a reality. Whether you\'re saving for a dream vacation, a down payment on a house, or an emergency fund, our goal-oriented feature helps you track your progress and stay motivated. We believe in holding you accountable every step of the way.'
                      ),
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.5
                        ),
                        text: '\n\nPersonalized Budgeting:',
                      ),
          
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.5
                        ),
                        text: '  Create budgets tailored to your unique needs and lifestyle. Set spending limits for different categories, and receive real-time notifications to keep your spending in check. LiFi empowers you to make informed decisions, avoid overspending, and prioritize your financial well-being.'
                      ),



                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.5
                        ),
                        text: '\n\nPlanners:',
                      ),
          
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.5
                        ),
                        text: '  Plan your purchases wisely to avoid impulsive buying and ensure your expenses align with your financial goals. Planner allows you to jot down your intended purchases and suggests suitable options based on factors such as price, scale of preference, and estimated satisfaction. Make informed choices and stay on track with your financial priorities.'
                      ),


       
          
          
          
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.5
                        ),
                        text: '\n\nInsights and Reports:',
                      ),
          
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.5
                        ),
                        text: '  Gain valuable insights into your financial health through our powerful reporting tools. Visualize your spending patterns, analyze trends, and identify areas for improvement. With clear and comprehensive reports, you\'ll have the information you need to make sound financial decisions.'
                      ),
          
          
          
          
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.5
                        ),
                        text: '\n\nBackup and Sync:',
                      ),
          
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.5
                        ),
                        text: '  Rest assured that your financial data is safe and accessible whenever you need it. LiFi offers automatic backup and sync functionality, ensuring that your information is securely stored and seamlessly available across all your devices. Never worry about losing your financial data again.'
                      ),
          
          
          
          
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.5
                        ),
                        text: '\n\nAccountability and Support:',
                      ),
          
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.5
                        ),
                        text: '  We understand the importance of accountability. LiFi encourages responsible financial behavior and guides you towards your goals. Engage with a community of like-minded individuals, seek advice, and share your experiences. Our dedicated support team is also ready to assist you every step of the way.'
                      ),
          
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.5
                        ),
                        text: '\n\nRemember, with LiFi, you are not just managing your money – you\'re transforming your relationship with it.'
                      )
                    ]
                  )
                ),

                const SizedBox(height: 20,)
              ]
            ),
          ),
        ),

/////////////////////////////
////////////////////////////
               
        ),

   );
  }
}
