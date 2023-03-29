import 'package:chatgpt_app/msg_class.dart';

class ResultModel{
  bool ok = false;
  String msg = "";
  MsgModel? result;

  ResultModel.full(this.ok, this.msg);

  ResultModel();
}