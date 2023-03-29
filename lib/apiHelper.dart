import 'package:chatgpt_app/msg_class.dart';
import 'package:chatgpt_app/result_class.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiHelper {
  static Future<ResultModel> apiGetAnswer(String question) async {
    ResultModel result;

    try {
      Map<String, dynamic> theData = {'msg': question};
      final req = await http.post(Uri.parse("http://localhost:3008/simplechat"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: jsonEncode(theData));
      var apiResp = jsonDecode(req.body);
      if (apiResp["ok"]) {
        result = ResultModel.full(true, "Exito");
        result.result = MsgModel.full(TipoMsg.respuesta, apiResp["result"]);
      } else {
        result = ResultModel.full(false, apiResp["msg"]);
      }
    } catch (e) {
      result = ResultModel.full(false, "Excepcion al enviar peticion: $e");
    }
    return result;
  }
}
