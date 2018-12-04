unit formDetallesPedidos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, Grids, ExtCtrls,  DbCtrls,
  DBGrids, StdCtrls;

type

  { TfrmDetallePedidos }

  TfrmDetallePedidos = class(TForm)
    grillaDetallesPedidos: TStringGrid;
    edtFecha: TLabeledEdit;
    edtVendedor: TLabeledEdit;
    edtCliente: TLabeledEdit;
    total: TLabeledEdit;
    volver: TImage;
    procedure volverClick(Sender: TObject);

  private

  public

  end;

var
  frmDetallePedidos: TfrmDetallePedidos;

implementation

{$R *.lfm}

{ TfrmDetallePedidos }



procedure TfrmDetallePedidos.volverClick(Sender: TObject);
begin
  Close;
end;

end.

