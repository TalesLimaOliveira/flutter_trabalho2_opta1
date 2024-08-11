import 'package:flutter_trabalho2_opta1/commons.dart';


class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppLabels.appBarList),
        automaticallyImplyLeading: false,
      ),

//SCREEN STYLE
      body: Consumer<ExpenseDao>(
        builder: (context, controller, child) {
          return Container(
            padding: const EdgeInsets.all(2.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.containerBG,
              borderRadius: BorderRadius.circular(16),
            ),

//LIST BUILDER INDEX
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.expenseList.length,
                    itemBuilder: (context, index) {
                      final expenseList = controller.expenseList[index];

//LIST                
                      return ListTile(
                        title: Text(expenseList.purpose),
                        subtitle: Text(expenseList.toSubtitle()),
  //LIST ICONS                          
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
  //EDIT FROM LIST          
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute( 
                                    builder: (context) =>
                                    ExpenseForm(existingExpense: expenseList)
                                  ),
                                );
                              },
                            ),
  //DELETE FROM LIST
                            IconButton(
                              icon: const Icon(Icons.delete),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                controller.deleteExpense(expenseList.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          );
        }
      ),

//ADD BUTTON
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ExpenseForm()
            ),
          );
        },
      ),
    );
  }
}
