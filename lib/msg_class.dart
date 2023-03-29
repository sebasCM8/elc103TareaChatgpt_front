enum TipoMsg { pregunta, respuesta }

class MsgModel {
  TipoMsg tipoMsg;
  String msg = "";
  MsgModel.full(this.tipoMsg, this.msg);
}
