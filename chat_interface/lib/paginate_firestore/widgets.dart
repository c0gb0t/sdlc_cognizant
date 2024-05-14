import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {
  const BottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 24),
        child: SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}




class EmptyDisplay extends StatelessWidget {
  const EmptyDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No documents found'));
  }
}


class EmptySeparator extends StatelessWidget {
  const EmptySeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 0, width: 0);
  }
}



class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({Key? key, required this.exception}) : super(key: key);

  final Exception exception;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Error occured: $exception'));
  }
}



class InitialLoader extends StatelessWidget {
  const InitialLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
  }
}