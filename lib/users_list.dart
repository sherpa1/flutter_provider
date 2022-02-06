import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class User {
  String? uuid;
  String? firstname;
  String? lastname;
  String? email;
  String? gender;
  bool favorite = false;

  User(this.uuid, this.firstname, this.lastname, this.email, this.gender);

  String fullname() {
    return firstname! + " " + lastname!;
  }
}

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  static const routeName = '/users-master';

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  var _users = <User>[];

  var uuid = const Uuid();
  var rng = Random();

  @override
  initState() {
    super.initState();

    _users = List.generate(
      50,
      (index) => User(
        uuid.v4(),
        faker.person.firstName(),
        faker.person.lastName(),
        faker.internet.email(),
        (rng.nextInt(1) > 0) ? "Male" : "Female",
      ),
    );
  }

  void _onPress() {
    setState(() {
      _users.insert(
        0,
        User(
          uuid.v4(),
          faker.person.firstName(),
          faker.person.lastName(),
          faker.internet.email(),
          (rng.nextInt(1) > 0) ? "Male" : "Female",
        ),
      );
    });
  }

  Widget _usersList() {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemCount: _users.length,
      itemBuilder: (BuildContext context, int index) {
        return UserPreview(user: _users[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
      ),
      body: _usersList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPress,
        tooltip: 'Add a contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserPreview extends StatefulWidget {
  const UserPreview({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<UserPreview> createState() => _UserPreviewState();
}

class _UserPreviewState extends State<UserPreview> {
  late User? user;

  @override
  initState() {
    super.initState();
    user = widget.user;
  }

  void onTap() {
    Navigator.pushNamed(
      context,
      UserDetailsArguments.routeName,
      arguments: UserDetailsArguments(user: widget.user),
    );
  }

  void _onFavoriteUpdate(bool favorite) {
    setState(() {
      user!.favorite = favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: user!.favorite == true ? Colors.red[50] : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => onTap(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user!.fullname(),
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          ToggleFavorite(user: user!, onUpdate: _onFavoriteUpdate)
        ],
      ),
    );
  }
}

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  void _onFavoriteUpdate(bool favorite) {
    setState(() {
      user.favorite = favorite;
      widget.user.favorite = favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User's Details"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(user.uuid!),
            Text(user.firstname!),
            Text(user.lastname!),
            Text(user.email!),
            Text(user.gender!),
            ToggleFavorite(user: user, onUpdate: _onFavoriteUpdate)
          ],
        ),
      ),
    );
  }
}

class UserDetailsArguments {
  final User user;

  static const routeName = '/users-details';

  UserDetailsArguments({required this.user});
}

class ToggleFavorite extends StatefulWidget {
  const ToggleFavorite({Key? key, required this.user, required this.onUpdate})
      : super(key: key);

  final User user;
  final Function onUpdate;

  @override
  State<ToggleFavorite> createState() => _ToggleFavoriteState();
}

class _ToggleFavoriteState extends State<ToggleFavorite> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  void _toggle() {
    var newValue = (user.favorite == true) ? false : true;

    setState(() {
      user.favorite = newValue;
      widget.onUpdate(user.favorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _toggle(),
      icon: Icon((user.favorite == false)
          ? Icons.favorite_border_outlined
          : Icons.favorite),
      color: Colors.red,
    );
  }
}