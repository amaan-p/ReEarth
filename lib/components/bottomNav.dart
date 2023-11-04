import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/Home.dart';
class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            selectedFontSize: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: selectedIndex,
            onTap: onTabSelected,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color: selectedIndex == 0
                        ? Color.fromARGB(255, 139, 195, 74)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: FaIcon(
                      size: 28,
                      FontAwesomeIcons.houseChimneyUser,
                      color: selectedIndex == 0 ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color: selectedIndex == 1
                        ? Color.fromARGB(255, 139, 195, 74)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: FaIcon(
                      size: 28,
                      FontAwesomeIcons.recycle,
                      color: selectedIndex == 1 ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                label: 'Recycle',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color: selectedIndex == 2
                        ? Color.fromARGB(255, 139, 195, 74)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: FaIcon(
                      size: 28,
                      FontAwesomeIcons.boxOpen,
                      color: selectedIndex == 2 ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                label: 'Community',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

