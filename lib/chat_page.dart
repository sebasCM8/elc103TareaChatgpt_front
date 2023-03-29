import 'package:chatgpt_app/apiHelper.dart';
import 'package:chatgpt_app/msg_class.dart';
import 'package:chatgpt_app/result_class.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _msgCtrl = TextEditingController();
  List<MsgModel> _messages = [];

  bool _loading = false;

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Widget chatMsg(MsgModel msg) {
    return Align(
      alignment: (msg.tipoMsg == TipoMsg.pregunta)
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: (msg.tipoMsg == TipoMsg.pregunta)
                ? const Color.fromARGB(255, 141, 204, 234)
                : const Color.fromARGB(255, 228, 191, 142),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.blueGrey, offset: Offset(1, 1), blurRadius: 2),
              BoxShadow(
                  color: Colors.blueGrey, offset: Offset(-1, -1), blurRadius: 2)
            ]),
        margin: const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 4),
        padding: const EdgeInsets.all(18),
        child: Text(msg.msg),
      ),
    );
  }

  Future<ResultModel> getAnswerProc(String msgTxt) async {
    ResultModel result;
    try {
      result = await ApiHelper.apiGetAnswer(msgTxt);
    } catch (e) {
      result = ResultModel.full(false, "Excepxion: $e");
    }
    return result;
  }

  Future<void> respDialog(BuildContext context, String msg) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              msg,
              style: const TextStyle(color: Colors.red),
            ),
          );
        });
  }

  Future<void> sendMessage() async {
    if (_msgCtrl.text != "") {
      String mensaje = _msgCtrl.text.trim();
      setState(() {
        _loading = true;
        _messages.add(MsgModel.full(TipoMsg.pregunta, mensaje));
        _msgCtrl.text = "";
      });

      ResultModel procResult = await getAnswerProc(mensaje);
      if (procResult.ok) {
        _messages.add(procResult.result!);
      } else {
        respDialog(context, procResult.msg);
      }

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatea con CHATGPT")),
      body: Column(children: [
        Expanded(
            child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int item) {
                  return chatMsg(_messages[item]);
                })),
        const Divider(),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    controller: _msgCtrl,
                  ),
                ),
              ),
              if (!_loading)
                IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ))
            ],
          ),
        ),
        if (_loading)
          Container(
            padding: const EdgeInsets.all(12),
            child: const CircularProgressIndicator(
              strokeWidth: 12,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
      ]),
    );
  }
}
