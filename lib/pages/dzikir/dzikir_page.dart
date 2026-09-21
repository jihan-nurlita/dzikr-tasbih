// Container(
//   width: double.infinity,
//   padding: const EdgeInsets.all(20),
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(30),
//     color: theme.accentColor.withOpacity(0.1),
//     border: Border.all(
//       color: theme.accentColor.withOpacity(0.1),
//     ),
//   ),
//   child: InkWell(
//     borderRadius: BorderRadius.circular(24),

//     onTap: () {
//       showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,

//         builder: (context) {
//           final controller = TextEditingController(
//             text: provider.currentDzikir.target.toString(),
//           );

//           return Container(
//             padding: const EdgeInsets.all(24),

//             decoration: const BoxDecoration(
//               color: Color(0xFF081C15),

//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(32),
//               ),
//             ),

//             child: StatefulBuilder(
//               builder: (context, setModalState) {
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,

//                   children: [
//                     Center(
//                       child: Container(
//                         width: 60,
//                         height: 6,
//                         decoration: BoxDecoration(
//                           borderRadius:
//                               BorderRadius.circular(20),
//                           color: Colors.white24,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     const Text(
//                       "Dzikir Settings",
//                       style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 28),

//                     /// DZIKIR LIST
//                     ...List.generate(
//                       dzikirList.length,
//                       (index) {
//                         final dzikir =
//                             dzikirList[index];

//                         final isSelected =
//                             provider.selectedDzikirIndex ==
//                                 index;

//                         return Padding(
//                           padding:
//                               const EdgeInsets.only(
//                             bottom: 14,
//                           ),

//                           child: InkWell(
//                             borderRadius:
//                                 BorderRadius.circular(
//                               20,
//                             ),

//                             onTap: () {
//                               provider.changeDzikir(
//                                 index,
//                               );

//                               setModalState(() {});
//                             },

//                             child: AnimatedContainer(
//                               duration:
//                                   const Duration(
//                                 milliseconds: 250,
//                               ),

//                               padding:
//                                   const EdgeInsets.all(
//                                 18,
//                               ),

//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.circular(
//                                   20,
//                                 ),

//                                 color: isSelected
//                                     ? theme.accentColor
//                                         .withOpacity(
//                                         0.15,
//                                       )
//                                     : Colors.white
//                                         .withOpacity(
//                                         0.03,
//                                       ),

//                                 border: Border.all(
//                                   color: isSelected
//                                       ? theme
//                                           .accentColor
//                                       : Colors
//                                           .transparent,
//                                 ),
//                               ),

//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons
//                                         .auto_awesome,
//                                     color:
//                                         theme.accentColor,
//                                   ),

//                                   const SizedBox(
//                                     width: 14,
//                                   ),

//                                   Expanded(
//                                     child: Text(
//                                       dzikir.title,
//                                       style:
//                                           const TextStyle(
//                                         fontWeight:
//                                             FontWeight
//                                                 .w600,
//                                       ),
//                                     ),
//                                   ),

//                                   Text(
//                                     "${dzikir.target}",
//                                     style: TextStyle(
//                                       color: theme
//                                           .accentColor,
//                                       fontWeight:
//                                           FontWeight
//                                               .bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),

//                     const SizedBox(height: 20),

//                     /// CUSTOM TARGET
//                     const Text(
//                       "Custom Target",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 14),

//                     TextField(
//                       controller: controller,

//                       keyboardType:
//                           TextInputType.number,

//                       style: const TextStyle(
//                         color: Colors.white,
//                       ),

//                       decoration: InputDecoration(
//                         hintText:
//                             "Example: 1000",

//                         hintStyle:
//                             const TextStyle(
//                           color: Colors.white38,
//                         ),

//                         filled: true,

//                         fillColor: Colors.white
//                             .withOpacity(0.05),

//                         prefixIcon: Icon(
//                           Icons.track_changes,
//                           color: theme.accentColor,
//                         ),

//                         border:
//                             OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.circular(
//                             20,
//                           ),
//                           borderSide:
//                               BorderSide.none,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 28),

//                     SizedBox(
//                       width: double.infinity,

//                       child: ElevatedButton(
//                         onPressed: () {
//                           final value =
//                               int.tryParse(
//                             controller.text,
//                           );

//                           if (value != null &&
//                               value > 0) {
//                             provider.changeTarget(
//                               value,
//                             );
//                           }

//                           Navigator.pop(
//                             context,
//                           );
//                         },

//                         style:
//                             ElevatedButton.styleFrom(
//                           elevation: 0,

//                           backgroundColor:
//                               theme.accentColor,

//                           foregroundColor:
//                               Colors.black,

//                           padding:
//                               const EdgeInsets.symmetric(
//                             vertical: 18,
//                           ),

//                           shape:
//                               RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.circular(
//                               22,
//                             ),
//                           ),
//                         ),

//                         child: const Text(
//                           "Apply Settings",
//                           style: TextStyle(
//                             fontWeight:
//                                 FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),

//                     SizedBox(
//                       height: MediaQuery.of(
//                             context,
//                           ).viewInsets.bottom,
//                     ),
//                   ],
//                 );
//               },
//             ),
//           );
//         },
//       );
//     },

//     child: Row(
//       children: [
//         Container(
//           width: 60,
//           height: 60,

//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: theme.accentColor.withOpacity(
//               0.15,
//             ),
//           ),

//           child: Icon(
//             Icons.auto_awesome,
//             color: theme.accentColor,
//           ),
//         ),

//         const SizedBox(width: 18),

//         Expanded(
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,

//             children: [
//               Text(
//                 provider.currentDzikir.title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               const SizedBox(height: 6),

//               Text(
//                 "Target ${provider.currentDzikir.target}",
//                 style: const TextStyle(
//                   color: Colors.white70,
//                 ),
//               ),
//             ],
//           ),
//         ),

//         Icon(
//           Icons.keyboard_arrow_up_rounded,
//           color: theme.accentColor,
//           size: 32,
//         ),
//       ],
//     ),
//   ),
// ),