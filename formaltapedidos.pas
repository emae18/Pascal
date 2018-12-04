unit formAltaPedidos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  unidadCentral, Dialogs, ExtCtrls, StdCtrls, Grids, ComCtrls, Buttons, Spin,
  EditBtn, formPrincipal;

type

  { TfrmAltaPedidos }

  TfrmAltaPedidos = class(TForm)
    btnAgregar: TBitBtn;
    btnCancelar: TButton;
    btnConfirmar: TButton;
    cbClientes: TComboBox;
    cbProductos: TComboBox;
    dtFecha: TDateEdit;
    editCantidad: TSpinEdit;
    editID: TLabeledEdit;
    Image13: TImage;
    Image4: TImage;
    Image5: TImage;
    lbCargo3: TLabel;
    lbUser3: TLabel;
    Panel1: TPanel;
    salir3: TLabel;
    strGrilla: TStringGrid;
    titulo3: TLabel;
    total1: TStaticText;
    procedure btnAgregarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure a(Sender: TObject);
    procedure UpDown1Click(Sender: TObject);
  private

  public

  end;

var
  frmAltaPedidos: TfrmAltaPedidos;
  vDetPed: Array [1..100] of RDetallePedido;
  n:integer;
  items:integer;
  tot: real;
  cliente: RCliente;
  fecha:  cad;
   foFPedidos:fileOfPedidos;
   usuPed: RUser;
implementation
{$R *.lfm}

function buscarVend(ven : cad):RUser;
var
    f:fileOfUsuarios;aux,usu:RUser;
begin
    assign(f,dirUsuarios);
    if(archivoAbiertoUsers(f)=0)then
    begin
       while(not eof(f)) do
       begin
         read(f,usu);
         if(usu.nombre=ven)then
         aux:=usu;
       end;
    end;
    system.close(f);
    buscarVend:=aux;
end;

procedure crearPedido(id: integer;preFinal:real;c:RCliente;fecha:cad);
var
    n,i:integer;ped:RPedido; v:array [1..100] of RPedido;
begin
   i:=1;
   v[1].id:=id;
   v[1].fecha:=fecha;
   v[1].estado:='Iniciado';
   v[1].cliente:=c;
   v[1].impTotal:=preFinal;
   v[1].vendedor:=buscarVend(frmAltaPedidos.lbUser3.Caption);
   n:=2;
   system.Assign(foFPedidos,dirPedidos);
   reset(foFPedidos);
   while(not eof(foFPedidos)) do
   begin
       read(foFPedidos,ped);
       v[n]:=ped;
       n:=n+1;
   end;
   close(foFPedidos);
   system.Assign(foFPedidos,dirPedidos);
   rewrite(foFPedidos);
   while(i<n)do
   begin
     write(foFPedidos,v[i]);
     i:=i+1;
   end;
   close(foFPedidos);
end;

procedure agregarPedido(prod: RProducto);
var
  i:integer; p:RDetallePedido; f: fileofDetallePedido;
begin
     vDetPed[1].id:=strtoint(frmAltaPedidos.editID.Text);
     vDetPed[1].producto:=prod;
     vDetPed[1].numSerial:=items;
     vDetPed[1].cantidad:=strtoint(frmAltaPedidos.editCantidad.Caption);
     vDetPed[1].precioUnitario:=prod.precio;
     vDetPed[1].subtotal:=prod.precio*strtoint(frmAltaPedidos.editCantidad.Caption);
     system.assign(f,dirDetallePedidos);
      reset(f);
      i:=1;
      n:=2;
     while(not eof(f)) do
     begin
       read(f,p);
       vDetPed[n]:=p;
       n:=n+1;
     end;
     system.close(f);
     system.assign(f,dirDetallePedidos);
     rewrite(f);
     while(i<n)do
     begin
          write(f,vDetPed[i]);
          i:=i+1;
     end;
     close(f);

end;

procedure cargarGrilla();
var
  i:integer;p:RDetallePedido; f:fileOfDetallePedido;
begin
i:=1;
  assign(f,dirDetallePedidos);
  frmAltaPedidos.strGrilla.RowCount:=1;
  Reset(f);
  while(not eof(f)) do
  begin
        read(f,p);
       if(p.id=strtoint(frmAltaPedidos.editID.Text))then
       begin
       frmAltaPedidos.strGrilla.RowCount:=frmAltaPedidos.strGrilla.RowCount+1;
       frmAltaPedidos.strGrilla.Cells[0,i]:=inttostr(p.producto.id);
       frmAltaPedidos.strGrilla.Cells[1,i]:=p.producto.nombre;
       frmAltaPedidos.strGrilla.Cells[2,i]:=inttostr(p.producto.dimension);
       frmAltaPedidos.strGrilla.Cells[3,i]:=inttostr(p.cantidad);
       frmAltaPedidos.strGrilla.Cells[4,i]:=floattostr(p.precioUnitario);
       frmAltaPedidos.strGrilla.Cells[5,i]:=floattostr(p.subtotal);
       i:=i+1;
       end;
  end;
  close(f);
end;

function encontrarProducto(cod:integer):RProducto;
var
   aux,p:RProducto; f:fileOfProductos;
begin
     system.assign(f, dirProductos);
     reset(f);
     while (not eof(f)) do
     begin
       read(f,p);
       if(p.id=cod)then
       begin
         aux:=p;
       end;
     end;
     system.close(f);
     encontrarProducto:=aux;
end;

procedure cargarGrillaPedidos();
var
   x: fileOfPedidos;i:integer; ped:RPedido;
begin
     i:=1;
     frmPrincipal.grillaPedidos.RowCount:=1;
   system.assign(x,dirPedidos);
   Reset(x);
   while( not eof(x))do
   begin
          frmPrincipal.grillaPedidos.RowCount:=frmPrincipal.grillaPedidos.RowCount+1;
           read(x,ped);
           frmPrincipal.grillaPedidos.Cells[0,i]:=inttostr(ped.id);
           frmPrincipal.grillaPedidos.Cells[1,i]:=ped.fecha;
           frmPrincipal.grillaPedidos.Cells[2,i]:=ped.cliente.nombre;
           frmPrincipal.grillaPedidos.Cells[3,i]:=ped.estado;
           frmPrincipal.grillaPedidos.Cells[4,i]:=floattostr(ped.impTotal);
           i:=i+1;
   end;
   close(x);

end;

procedure buscarCliente(pos: cad);
var
   cli,aux:RCliente;c:fileOfClientes;
begin
   system.assign(c,dirClientes);
   reset(c);
   while(not eof(c)) do
   begin
        read(c,cli);
        if(pos=cli.nombre)then
        begin
        aux:=cli;
        end;
   end;
   close(c);
   cliente:=aux;
end;

{ TfrmAltaPedidos }

procedure disminuirStock(a: RProducto);
var
   i,n:integer;v: array [1..100] of RProducto; pr:fileOfProductos; prod: RProducto;
begin
    system.Assign(pr,dirProductos);
    reset(pr);n:=1;
    i:=1;
    while not eof(pr) do
    begin
        read(pr,prod);
        if(a.id=prod.id)then
        begin
           prod:=a;
        end;
        v[i]:=prod;
        i:=i+1;
    end;
    system.close(pr);
    system.Assign(pr,dirProductos);
    rewrite(pr);
    for n:=1 to i-1 do
    begin
        write(pr,v[n]);
    end;
    system.close(pr);
end;

procedure TfrmAltaPedidos.a(Sender: TObject);
var
  p:RProducto; f:fileOfProductos; c:RCliente; cf:fileOfClientes;
begin
     system.assign(f, dirProductos);
     reset(f);
     while (not eof(f)) do
     begin
       read(f,p);
       cbProductos.Items.Add(inttostr(p.id));
     end;
     system.close(f);
     system.assign(cf,dirClientes);
     reset(cf);
     while( not eof(cf))do
     begin
       read(cf,c);
       cbClientes.Items.Add(c.nombre);
     end;
     system.close(cf);
     editID.Text:=inttostr(generarIdPedido());

end;

procedure TfrmAltaPedidos.UpDown1Click(Sender: TObject);
begin
  cargarGrillaPedidos();
end;

procedure TfrmAltaPedidos.btnAgregarClick(Sender: TObject);
var
  prod: RProducto; c:RCliente;i:integer;
begin
 if(cbProductos.Caption='Productos') or( cbClientes.Caption='Clientes')then
 ShowMessage('Por favor seleccione un producto y un cliente')
 else
  begin
  cbClientes.Enabled:=false;
  dtFecha.Enabled:=false;
  prod :=encontrarProducto(strtoint(cbProductos.Caption));
  if(prod.stock<strtoint(editCantidad.Text))then
  ShowMessage('NO hay stock suficiente del producto')
  else
  begin
  i:=cbProductos.ItemIndex;
  cbProductos.Items.Delete(i);
  agregarPedido(prod);

  prod.stock:=prod.stock-strtoint(editCantidad.Text);
  disminuirStock(prod);

  c.nombre:=cbClientes.text;
  buscarCliente(c.nombre);
  cargarGrilla();
  tot:=tot+(prod.precio*strtoint(editCantidad.Text));
  fecha:=DateToStr(dtFecha.Date);
  total1.Caption:=floattostr(tot);
  end;

end;
end;

procedure TfrmAltaPedidos.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAltaPedidos.btnConfirmarClick(Sender: TObject);
var
  i:integer;
begin
  i:=strtoint(editID.Text);
  crearPedido(i,tot,cliente,fecha);
  cargarGrillaPedidos();
  cbClientes.Enabled:=true;
  dtFecha.Enabled:=true;
  tot:=0.00;


  close();

end;


end.

