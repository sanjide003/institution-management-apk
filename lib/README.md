[1] material.dart library: it contains Button,Text,Scaffold.


[2]Main method: in Java, public static void main(String[] args)
{
    new MyApp();
}

[3]  .. extends StatelessWidget{}:  in Java, public class MyApp extends JFrame{}


[4]It means Constructor in Java, logic is same. MyApp({super.key});

--> const: constant

-->StatelessWidget: Static display

-->StatefulWidget: Dynamic display

[5]debugShowCheckedModeBanner: remove debug flag on the Android SDK simulator screen

[6]State<CounterScreen> createState() => : State is momentary state of screen. And it has generic. We have to override to createState() method. Because it is abstract method in parent class.


[7] _CounterScreenState: CounterScreenState class is private.

[8] setState() : call back to build() for show updates.

--> Column() : It contains many widget. So, we use children in Column.
