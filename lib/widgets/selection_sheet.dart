
 import 'package:flutter/material.dart';

Future optionWidget(
  BuildContext context,
  {
    required List options,
    void Function(dynamic)? onTap,
    String? heading,
    bool enableSearch = false
  }
  ) async{

  //final contoller = ScrollController();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {

        return ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Container(
            height: (MediaQuery.of(context).size.height/2),
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                heading??'Choose an option',
                              
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
        
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.close_rounded, color: Color.fromARGB(255, 53, 52, 52),)
                                ),
                            ],
                          )
                        ],
                        ),
                  ),
                ),
        
        
                Flexible(
                  
                  flex: 9,
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index){
                      return 
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, ),
                          child: GestureDetector(
                            onTap: (){
                              onTap!(options[index]);
                              Navigator.pop(context);
                            }, 
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(
                                  color: Color.fromARGB(31, 193, 190, 190)
                                ))
                              ),

                              child: FractionallySizedBox(
                                widthFactor: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                    Row(
                                      children: [
                                        Text(
                                          options[index].name??options[index].title, 
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                          )),
                                      ],
                                    ),
                                
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
    }
  );
}
