program tpFinal;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, formLogin, unidadCentral, formAltaUsuario,
  formPrincipal, formAltaPedidos, formAltaProducto ,formAltaClientes,formDetallesPedidos;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmAltaUsuario, frmAltaUsuario);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmDetallePedidos, frmDetallePedidos);
  Application.CreateForm(TfrmAltaPedidos, frmAltaPedidos);
  Application.CreateForm(TfrmAltaProd, frmAltaProd);
  Application.CreateForm(TfrmClientes, frmClientes);
  Application.Run;
end.

