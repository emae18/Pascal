unit formPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, unidadCentral, formLogin, Controls,
  Graphics, Dialogs, ComCtrls, Buttons, Grids, ExtCtrls, StdCtrls, EditBtn;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    botonEliminar: TImage;
    botonModificar: TImage;
    btnBusFecha: TImage;
    btnBusPed: TImage;
    btnNUEVO: TImage;
    btnProdNuevo: TBitBtn;
    btnProdEliminar: TBitBtn;
    btnProdModificar: TBitBtn;
    botonCancelar: TBitBtn;
    botonConfirmar: TBitBtn;
    botonNuevo1: TBitBtn;
    botonPedido: TBitBtn;
    buscarPRODUCTO: TImage;
    buscar: TButton;
    cbPedClientes: TComboBox;
    cbPedVendedores: TComboBox;
    dtBusFec: TDateEdit;
    editBuscaPRODUCTO: TEdit;
    editBuscar: TEdit;
    grillaCuentas: TStringGrid;
    botonBuscar: TImage;
    botonNuevo: TImage;
    Image1: TImage;
    fondo: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    lbCargo1: TLabel;
    lbCargo2: TLabel;
    lbCargo3: TLabel;
    lbUser1: TLabel;
    lbUser2: TLabel;
    lbUser4: TLabel;
    Panel1: TPanel;
    salir: TLabel;
    lbUser: TLabel;
    lbCargo: TLabel;
    salir1: TLabel;
    salir2: TLabel;
    Productos: TTabSheet;
    grillaProductos: TStringGrid;
    salir3: TLabel;
    titulo: TLabel;
    pagPrincipal: TPageControl;
    titulo1: TLabel;
    titulo2: TLabel;
    titulo3: TLabel;
    grillaPedidos: TStringGrid;
    StrCuentas3: TStringGrid;
    Usuarios: TTabSheet;
    Pedidos: TTabSheet;
    Clientes: TTabSheet;
    procedure botonBuscarClick(Sender: TObject);
    procedure botonCancelarClick(Sender: TObject);
    procedure botonConfirmarClick(Sender: TObject);
    procedure botonEliminarClick(Sender: TObject);
    procedure botonModificarClick(Sender: TObject);
    procedure botonNuevo1Click(Sender: TObject);
    procedure botonNuevoClick(Sender: TObject);
    procedure botonPedidoClick(Sender: TObject);
    procedure btnBusFechaClick(Sender: TObject);
    procedure btnMODIFCARClick(Sender: TObject);
    procedure btnNUEVOClick(Sender: TObject);
    procedure btnProdEliminarClick(Sender: TObject);
    procedure btnProdModificarClick(Sender: TObject);
    procedure btnProdNuevoClick(Sender: TObject);
    procedure btnBusPedClick(Sender: TObject);
    procedure buscarClick(Sender: TObject);
    procedure buscarPRODUCTOClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure salirClick(Sender: TObject);
  private

  public

  end;


var
  frmPrincipal: TfrmPrincipal;
  fofCliente:fileOfClientes;
  productos:fileOfProductos;

implementation

uses formAltaUsuario,formAltaPedidos,formAltaClientes,formAltaProducto,formDetallesPedidos;

procedure cargarCbPed();
var
  cli:RCliente;
begin
   system.Assign(fOfCliente,dirClientes);
   reset(fOfCliente);
   while not EOF(fOfCliente) do
   begin
           read(fOfCliente,cli);
           frmPrincipal.cbPedClientes.Items.Add(cli.nombre);
   end;
   close(fOfCliente);
end;

procedure cargarCbU();
var
  usu:RUser;
  begin
   system.Assign(fOfUsers,dirUsuarios);
   reset(fOfUsers);
   while not eof(fOfUsers) do
   begin
           read(fOfUsers,usu);
           frmPrincipal.cbPedVendedores.Items.Add(usu.nombre);
   end;
   close(fOfUsers);
  end;

procedure buscarPedido(var a:RPedido);
var
  usuAux:RPedido; i:integer; ped:fileOfPedidos;
begin
       system.Assign(ped,dirPedidos);
       i:=1;
       reset(ped);
       while (not eof(ped)) and (i<>-1) do //mientras tenga para leer el archivo y no encuentre en usuario
        begin
          read(ped,usuAux);                  // leo
          if(a.id = usuAux.id)then
          begin
                a.estado:=usuAux.estado;
                a.cliente:=usuAux.cliente;
                a.fecha:=usuAux.fecha;
                a.impTotal:=usuAux.impTotal;
                a.vendedor:=usuAux.vendedor;
                i:=-1;
          end;
        end;
        close(ped);
end;

procedure cambiarEstad(var a: RPedido);
var
     usuAux:RPedido; n,i:integer; ped:fileOfPedidos; v: array [1..100] of RPedido;
begin
    system.Assign(ped,dirPedidos);
       i:=1;
       reset(ped);
       while (not eof(ped)) do //mientras tenga para leer el archivo y no encuentre en usuario
        begin
          read(ped,usuAux);                  // leo
          if(a.id = usuAux.id)then
          begin
               v[i]:=a;
          end
          else
          v[i]:=usuAux;
          i:=i+1;
        end;
        close(ped);
    rewrite(ped);
    for n:=1 to i-1 do
    begin
      write(ped,v[n]);
    end;
    close(ped);
end;

procedure cargarGrilla2;
var
    usAux:RCliente; i:integer;

begin
   if(archivoAbiertoCliente(fOfCliente) <> 0) then // si se abrio dara un número distinto de 0 y empezamos a trabajar con el archivo en else
    Close(fOfCliente)
  else
  begin
       i:=1;
       frmPrincipal.StrCuentas3.RowCount:=1;
       while not eof(fOfCliente) do //mientras tenga para leer el archivo y no encuentre en usuario
        begin
          frmPrincipal.StrCuentas3.RowCount:=frmPrincipal.StrCuentas3.RowCount+1;
          read(fOfCliente,usAux);                  // leo
          frmPrincipal.StrCuentas3.Cells[0,i]:=IntToStr(usAux.id);
          frmPrincipal.StrCuentas3.Cells[1,i]:=IntToStr(usAux.dni);
          frmPrincipal.StrCuentas3.Cells[2,i]:=usAux.nombre;
          frmPrincipal.StrCuentas3.Cells[3,i]:=usAux.domicilio;
          i:=i+1;
        end;
        close(fOfCliente);
  end;
end;

procedure cargarGrilla;
var
    usuAux:RUser; i:integer;
begin
   if(archivoAbiertoUsers(fOfUsers) <> 0) then // si se abrio dara un número distinto de 0 y empezamos a trabajar con el archivo en else
    Close(fOfUsers)
  else
  begin
       i:=1;
       frmPrincipal.grillaCuentas.RowCount:=1;
       while not eof(fOfUsers) do //mientras tenga para leer el archivo y no encuentre en usuario
        begin
          frmPrincipal.grillaCuentas.RowCount:=frmPrincipal.grillaCuentas.RowCount+1;
          read(fOfUsers,usuAux);                  // leo
          frmPrincipal.grillaCuentas.Cells[0,i]:=IntToStr(usuAux.id);
          frmPrincipal.grillaCuentas.Cells[1,i]:=IntToStr(usuAux.dni);
          frmPrincipal.grillaCuentas.Cells[2,i]:=usuAux.nombre;
          frmPrincipal.grillaCuentas.Cells[3,i]:=usuAux.rol;
          i:=i+1;
        end;
        close(fOfUsers);
  end;
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

procedure buscarPedidoFecha(var s:RPedido);
var
   p:fileOfPedidos;ped:RPedido; i:integer;
begin
   i:=1;
   system.assign(p,dirPedidos);
   Reset(p);
   frmPrincipal.grillaPedidos.RowCount:=1;
   while ( not eof(p)) do
   begin
        read(p,ped);
        if(ped.fecha=s.fecha)then
        begin
           frmPrincipal.grillaPedidos.RowCount:=frmPrincipal.grillaPedidos.RowCount+1;
           frmPrincipal.grillaPedidos.Cells[0,i]:=inttostr(ped.id);
           frmPrincipal.grillaPedidos.Cells[1,i]:=ped.fecha;
           frmPrincipal.grillaPedidos.Cells[2,i]:=ped.cliente.nombre;
           frmPrincipal.grillaPedidos.Cells[3,i]:=ped.estado;
           frmPrincipal.grillaPedidos.Cells[4,i]:=floattostr(ped.impTotal);
           i:=i+1;
        end;
   end;
   system.close(p);
end;

{$R *.lfm}

{ TfrmPrincipal }



{GESTION DE USUARIOS}
procedure buscarUsuario(var usu: RUser);
var
  usuAux:RUser; i:integer;
begin
    if(archivoAbiertoUsers(fOfUsers) <> 0) then // si se abrio dara un número distinto de 0 y empezamos a trabajar con el archivo en else
    Close(fOfUsers)
  else
  begin
       i:=1;
       while (not eof(fOfUsers)) and (i<>-1) do //mientras tenga para leer el archivo y no encuentre en usuario
        begin
          read(fOfUsers,usuAux);                  // leo
          if(usu.id = usuAux.id)then
          begin
                usu.dni:=usuAux.dni;
                usu.clave:=usuAux.clave;
                usu.nombre:=usuAux.nombre;
                usu.rol:=usuAux.rol;
                i:=-1;
          end;
        end;
        close(fOfUsers);
  end;
end;

procedure TfrmPrincipal.botonNuevoClick(Sender: TObject);
begin
     frmAltaUsuario.Caption:='AltaUsuario';
     frmAltaUsuario.Show;
end;

procedure TfrmPrincipal.botonPedidoClick(Sender: TObject);
var
  i:integer;ped:RPedido; det:RDetallePedido; dp:fileOfDetallePedido;monto:real;
begin
   ped.id:=StrToInt(frmPrincipal.grillaPedidos.Cells[0,frmPrincipal.grillaPedidos.Row]);
  buscarPedido(ped);
  monto:=0;
   system.Assign(dp,dirDetallePedidos);
   reset(dp);
   i:=1;
   frmDetallePedidos.grillaDetallesPedidos.RowCount:=1;
   frmDetallePedidos.edtCliente.Text:=ped.cliente.nombre;
   frmDetallePedidos.edtFecha.Text:=ped.fecha;
   frmDetallePedidos.edtVendedor.Text:=ped.vendedor.nombre;
   while(not eof(dp))do
    begin
      read(dp,det);
      if(det.id=ped.id)then
      begin
          frmDetallePedidos.grillaDetallesPedidos.RowCount:=frmDetallePedidos.grillaDetallesPedidos.RowCount+1;
          frmDetallePedidos.grillaDetallesPedidos.Cells[0,i]:=inttostr(det.producto.id);
          frmDetallePedidos.grillaDetallesPedidos.Cells[1,i]:=det.producto.nombre;
          frmDetallePedidos.grillaDetallesPedidos.Cells[2,i]:=inttostr(det.producto.dimension);
          frmDetallePedidos.grillaDetallesPedidos.Cells[3,i]:=inttostr(det.cantidad);
          frmDetallePedidos.grillaDetallesPedidos.Cells[4,i]:=floattostr(det.precioUnitario);
          frmDetallePedidos.grillaDetallesPedidos.Cells[5,i]:=floattostr(det.subtotal);
          monto:=monto+det.subtotal;
          i:=i+1;
      end;
    end;
    frmDetallePedidos.total.Caption:=FloatToStr(monto);
   system.Close(dp);
   frmDetallePedidos.Show;
end;

procedure TfrmPrincipal.btnBusFechaClick(Sender: TObject);
var
  a:RPedido;
begin

   a.fecha:=DateToStr(dtBusFec.Date);
   buscarPedidoFecha(a);

end;

procedure TfrmPrincipal.salirClick(Sender: TObject);
var
    mensaje:String;
begin
     mensaje := '¿Cerrar sesion?';
     if MessageDlg(mensaje, mtConfirmation,[mbYes, mbNo], 0) = mrYes then
     begin
     close;
     frmlogin.show;
     frmLogin.lbError.Caption:='';
     cbPedClientes.Items.Clear;
     cbPedVendedores.Items.Clear;
     end;
end;

procedure TfrmPrincipal.botonModificarClick(Sender: TObject);
var
    asuAux:RUser;
begin
     asuAux.id:=StrToInt(grillaCuentas.Cells[0,frmPrincipal.grillaCuentas.Row]);
     buscarUsuario(asuAux);
     frmAltaUsuario.Caption:='ModificarUsuario';
     frmAltaUsuario.editId.text:=inttostr(asuAux.id);
     frmAltaUsuario.editDni.text:=inttostr(asuAux.dni);
     frmAltaUsuario.editNombre.text:=asuAux.nombre;
     frmAltaUsuario.cbCategoria.text:=asuAux.rol;
     frmAltaUsuario.editClave.Text:=asuAux.clave;
     frmAltaUsuario.editClave2.Text:=asuAux.clave;
     frmAltaUsuario.visible:=true;
end;

procedure TfrmPrincipal.botonEliminarClick(Sender: TObject);
var
    usuAux:RUser;
begin
    usuAux.id:=StrToInt(grillaCuentas.Cells[0,frmPrincipal.grillaCuentas.Row]);
    eliminarUsuario(usuAux);
    frmPrincipal.botonBuscarClick(Sender);
end;






{GESTION CLIENTES}
procedure TfrmPrincipal.btnNUEVOClick(Sender: TObject);
begin
  frmClientes.Show;
end;

procedure TfrmPrincipal.btnMODIFCARClick(Sender: TObject);
{var
  cliente:RCliente; }
begin
    {cliente.id:=StrToInt(grillaCuentas.Cells[0,frmPrincipal.grillaCuentas.Row]); }
    {eliminarCliente(cliente);}
end;

procedure TfrmPrincipal.botonBuscarClick(Sender: TObject);
var
  c:RUser; i:integer;
  personal:fileOfUsuarios;
begin
    system.Assign(personal,dirUsuarios);
    if(archivoAbiertoUsers(personal) <> 0) or (editBuscar.text='') then // si se abrio dara un número distinto de 0 y empezamos a trabajar con el archivo en else
    begin
    System.Close(personal);
    cargarGrilla;
    end
  else
  begin
       i:=1;
          frmPrincipal.grillaCuentas.rowcount:=1;
          while (not eof(personal)) and (i<>-1) do //mientras tenga para leer el archivo y no encuentre en usuario
          begin
          read(personal,c);                  // leo
          if (editBuscar.text = c.nombre) then
          begin
          frmPrincipal.grillaCuentas.rowcount:=frmPrincipal.grillaCuentas.rowcount+1;
          frmPrincipal.grillaCuentas.Cells[0,i]:=IntToStr(c.id);
          frmPrincipal.grillaCuentas.Cells[1,i]:=IntToStr(c.dni);
          frmPrincipal.grillaCuentas.Cells[2,i]:=c.nombre;
          frmPrincipal.grillaCuentas.Cells[3,i]:=c.rol;
          i:=i+1;
          editBuscar.text:='';

          end;
          end;
          System.close(personal);
  end;
end;

procedure TfrmPrincipal.botonCancelarClick(Sender: TObject);
var
  a:RPedido;
begin
   a.id:=StrToInt(frmPrincipal.grillaPedidos.Cells[0,frmPrincipal.grillaPedidos.Row]);
   buscarPedido(a);
   a.estado:='Cancelado';
   cambiarEstad(a);
   cargarGrillaPedidos();
end;

procedure TfrmPrincipal.botonConfirmarClick(Sender: TObject);
var
  a:RPedido;
begin
   a.id:=StrToInt(frmPrincipal.grillaPedidos.Cells[0,frmPrincipal.grillaPedidos.Row]);
   buscarPedido(a);
   a.estado:='Confirmado';
   cambiarEstad(a);
   cargarGrillaPedidos();
end;





{GESTION PRODUCTO}
procedure buscarProduct (var pro: RProducto);
var
  Aux:RProducto; i:integer;
begin
    if(archivoAbiertoProducto(productos) <> 0) then // si se abrio dara un número distinto de 0 y empezamos a trabajar con el archivo en else
    Close(productos)
  else
  begin
       i:=1;
       while (not eof(productos)) and (i<>-1) do //mientras tenga para leer el archivo y no encuentre en usuario
        begin
          read(productos,Aux);                  // leo
          if(pro.id = Aux.id)then
          begin
                pro.nombre:=Aux.nombre;
                pro.precio:=Aux.precio;
                pro.dimension:=Aux.dimension;
                pro.stock:=Aux.stock;
                i:=-1;
          end;
        end;
        close(productos);
  end;
end;

procedure TfrmPrincipal.btnProdNuevoClick(Sender: TObject);

begin
  frmAltaProd.Caption:='AltaProducto';
  frmAltaProd.Show;
  frmAltaProd.edt1.Text:=IntToStr(generarIdProducto())


end;

procedure TfrmPrincipal.btnProdEliminarClick(Sender: TObject);
var
    Aux:RProducto;
begin
    Aux.id:=StrToInt(grillaProductos.Cells[0,frmPrincipal.grillaProductos.Row]);
    eliminarProducto(Aux);
    frmAltaProd.FormCreate(Sender);
end;

procedure TfrmPrincipal.btnProdModificarClick(Sender: TObject);
var
    Aux:RProducto;
begin
     Aux.id:=StrToInt(grillaProductos.Cells[0,frmPrincipal.grillaProductos.Row]);
     buscarProduct(Aux);
     frmAltaProd.Caption:='ModificarProducto';
     frmAltaProd.edt1.text:=inttostr(Aux.id);
     frmAltaProd.edt2.text:=Aux.nombre;
     frmAltaProd.edt3.text:=FloatToStr(Aux.Precio);
     frmAltaProd.edt4.text:=IntToStr(Aux.dimension);
     frmAltaProd.edt5.text:=IntToStr(Aux.stock);
     frmAltaProd.visible:=true;
end;






{GESTION PEDIDOS}
procedure TfrmPrincipal.botonNuevo1Click(Sender: TObject);
begin
  frmAltaPedidos.cbClientes.clear;
  frmAltaPedidos.cbProductos.clear;
  frmAltaPedidos.cbProductos.Text:='Productos';
  frmAltaPedidos.cbClientes.Text:='Clientes';
  frmAltaPedidos.strGrilla.RowCount:=1;
  frmAltaPedidos.editCantidad.Text:=inttostr(0);
  frmAltaPedidos.a(sender);
  frmAltaPedidos.show;
end;

procedure TfrmPrincipal.btnBusPedClick(Sender: TObject);
  var
     x: fileOfPedidos;i:integer; ped:RPedido;
  begin
  if(cbPedVendedores.Text = 'Vendedores') and(cbPedClientes.Text='Clientes')then
    begin
    MessageDlg ('Seleccione','Por favor seleccione una vendedor o cliente' ,mtWarning, [mbYes], 0);
    cargarGrillaPedidos();
    end
    else
    begin
       i:=1;
       frmPrincipal.grillaPedidos.RowCount:=1;
     system.assign(x,dirPedidos);
     Reset(x);
     while( not eof(x))do
     begin
             read(x,ped);
             if(ped.cliente.nombre=cbPedClientes.Text) or (ped.vendedor.nombre=cbPedVendedores.Text)then
             begin
             frmPrincipal.grillaPedidos.RowCount:=frmPrincipal.grillaPedidos.RowCount+1;
             frmPrincipal.grillaPedidos.Cells[0,i]:=inttostr(ped.id);
             frmPrincipal.grillaPedidos.Cells[1,i]:=ped.fecha;
             frmPrincipal.grillaPedidos.Cells[2,i]:=ped.cliente.nombre;
             frmPrincipal.grillaPedidos.Cells[3,i]:=ped.estado;
             frmPrincipal.grillaPedidos.Cells[4,i]:=floattostr(ped.impTotal);
             i:=i+1;
             end;
     end;
     system.close(x);
    end;
     cbPedClientes.Clear;
     cbPedClientes.Text:='Clientes';
     cbPedVendedores.Clear;
     cbPedVendedores.Text:='Vendedores';
     cargarCbPed();
     cargarCbU();
  end;

procedure TfrmPrincipal.buscarClick(Sender: TObject);
begin
  cargarGrilla2;
end;

procedure TfrmPrincipal.buscarPRODUCTOClick(Sender: TObject);
var
  b:RProducto; i:integer;
  producto:fileOfProductos;
  band:Boolean;
begin
    band:=false;
    system.Assign(producto,dirProductos);
    if(archivoAbiertoProducto(producto) <> 0) or (editBuscaPRODUCTO.text='') then // si se abrio dara un número distinto de 0 y empezamos a trabajar con el archivo en else
    begin
    System.Close(producto);
    frmAltaProd.FormCreate(Sender);
    end
  else
  begin
       i:=1;
          frmPrincipal.grillaProductos.rowcount:=1;
          while (not eof(producto)) do //mientras tenga para leer el archivo y no encuentre en usuario
          begin
          read(producto,b);                  // leo
          if (editBuscaPRODUCTO.text = b.nombre) then
          begin

          frmPrincipal.grillaProductos.rowcount:=frmPrincipal.grillaProductos.rowcount+1;
          frmPrincipal.grillaProductos.Cells[0,i]:=IntToStr(b.id);
          frmPrincipal.grillaProductos.Cells[1,i]:=b.nombre;
          frmPrincipal.grillaProductos.Cells[2,i]:=IntToStr(b.dimension);
          frmPrincipal.grillaProductos.Cells[3,i]:=FloatToStr(b.precio);
          frmPrincipal.grillaProductos.Cells[4,i]:=IntToStr(b.stock);

          i:=i+1;
          editBuscaPRODUCTO.text:='';
          band:=true;
          end

          end;
          System.close(producto);
          if (band=false) then
            begin
            MessageDlg ('No encontrado','El producto ingresado no existe' ,mtWarning, [mbYes], 0);
            editBuscaPRODUCTO.text:='';
            frmAltaProd.FormCreate(Sender);
            end;
  end;
end;


procedure TfrmPrincipal.FormActivate(Sender: TObject);
begin
     cargarGrillaPedidos();
     cargarCbPed();
     cargarCbU();
end;








{ADICIONALES}



procedure TfrmPrincipal.FormWindowStateChange(Sender: TObject);
begin

   frmLogin.close;
end;










end.

