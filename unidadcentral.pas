unit unidadCentral;

{$mode objfpc}{$H+}

interface

uses Dialogs;
CONST
  dirUsuarios = 'usuarios.dat';
  dirProductos = 'productos.dat';
  dirClientes = 'clientes.dat';
  dirPedidos = 'pedidos.dat';
  dirDetallePedidos = 'detallePedidos.dat';
  strAdmin = 'Administrador';
  strVend = 'Vendedor';
type

{REGISTROS}
cad= String[30];
RUser          =record
    id: integer;
    dni: integer;
    clave: cad;
    nombre: cad;
    rol: cad;
end;
RProducto      =record
  id: integer;
  nombre:String[30];
  dimension:integer;
  precio:real;
  stock: integer;
end;
RCliente       =record
  id:integer;
  dni:integer;
  nombre: cad;
  domicilio: cad;
end;
RPedido        =record
  id:integer;
  vendedor: RUser;
  cliente:RCliente;
  fecha:cad;
  impTotal: real;
  estado:cad;
end;
RDetallePedido =record
  id:integer;
  numSerial:integer;
  producto:RProducto;
  cantidad: Integer;
  precioUnitario:Real;
  subtotal:Real;
end;



{ARCHIVOS DAT}
fileOfUsuarios      = file of RUser;
fileOfProductos     = file of RProducto;
fileOfPedidos       = file of RPedido;
fileOfDetallePedido = file of RDetallePedido;
fileOfClientes      = file of RCliente;



procedure CreaArchivo(var f:fileOfUsuarios);
procedure CreaArchivoC();


function archivoAbiertoUsers(var f: fileOfUsuarios):integer;
function archivoAbiertoUsers2(var f: fileOfUsuarios):Integer;
procedure eliminarUsuario(a: RUser);


function archivoAbiertoCliente( var c: fileOfClientes):Integer;
function archivoAbiertoCliente2( var c: fileOfClientes):Integer;


function archivoAbiertoProducto (var p: fileOfProductos):Integer;
function archivoAbiertoProducto2  (var p: fileOfProductos):Integer;
procedure eliminarProducto(z: RProducto);


function generarIdUser():integer;
function generarIdProducto():integer;
function generarIdCliente():integer;
function generarIdPedido():integer;

procedure CreaArchivoPed();
procedure CreaArchivoD();

{procedure eliminarCliente(c: RCliente); }
{procedure modificar(m: RUser); }

implementation

{uses formAltaUsuario; }



{USUARIOS}
function archivoAbiertoUsers( var f: fileOfUsuarios):Integer;
begin
  assign(f,dirUsuarios); // asigno a mi fiche
  {$i-}
       reset(f); //Para verificar que se abra el archivo
  {$i+}
  archivoAbiertoUsers:=IOResult;
  end;

function archivoAbiertoUsers2( var f: fileOfUsuarios):Integer;
begin
  assign(f,dirUsuarios); // asigno a mi fiche
  {$i-}
       rewrite(f); //Para verificar que se abra el archivo
  {$i+}
            archivoAbiertoUsers2:=IOResult;
  end;

procedure eliminarUsuario(a: RUser);
var
   j,i:integer;
   usuario:RUser;
   v: array [1..100] of RUser;
   f:fileOfUsuarios;
begin
  i:=1;
  system.assign(f,dirUsuarios);
  if archivoAbiertoUsers(f)<>0 then
     ShowMessage('Error')
  else
    begin
      while not eof(f) do
      begin
        read(f,usuario);
        if(usuario.id<>a.id)then
        begin
            v[i]:=usuario;
            i:=i+1;
        end;
      end;
      close(f);
      if archivoAbiertoUsers2(f)<>0 then
       Close(f)
      else
          begin
            for j:=1 to i-1 do
            begin
              write(f,v[j]);
            end;
            close(f);
          end;

    end;
end;




{CLIENTES}
function archivoAbiertoCliente( var c: fileOfClientes):Integer;
begin
  assign(c,dirClientes); // asigno a mi fiche
  {$i-}
       reset(c); //Para verificar que se abra el archivo
  {$i+}
  archivoAbiertoCliente:=IOResult;
  end;

function archivoAbiertoCliente2( var c: fileOfClientes):Integer;
begin
  assign(c,dirClientes); // asigno a mi fiche
  {$i-}
       rewrite(c); //Para verificar que se abra el archivo
  {$i+}
            archivoAbiertoCliente2:=IOResult;
  end;

{procedure eliminarCliente(c: RCliente);
var
   j,i:integer;
   usuario:RCliente;  f:fileOfClientes;
   v: array [1..100] of RCliente;
begin
  i:=1;
  if archivoAbiertoCliente(f)<>0 then
     ShowMessage('Error')
  else
    begin
      while not eof(f) do
      begin
        read(f,usuario);
        if(usuario.id<>c.id)then
        begin
            v[i]:=usuario;
            i:=i+1;
        end;
      end;
      close(f);
      if archivoAbiertoCliente2(f)<>0 then
       Close(f)
      else
          begin
            for j:=1 to i-1 do
            begin
              write(f,v[j]);
            end;
            close(f);
          end;

    end;
end; }



{PRODUCTOS}

function archivoAbiertoProducto( var p: fileOfProductos):Integer;
begin
  assign(p,dirProductos); // asigno a mi fiche
  {$i-}
       reset(p); //Para verificar que se abra el archivo
  {$i+}
  archivoAbiertoProducto:=IOResult;
  end;

function archivoAbiertoProducto2( var p: fileOfProductos):Integer;
begin
  assign(p,dirProductos); // asigno a mi fiche
  {$i-}
       rewrite(p); //Para verificar que se abra el archivo
  {$i+}
   archivoAbiertoProducto2:=IOResult;
  end;

procedure eliminarProducto(z: RProducto);
var
   j,i:integer;
   producto:RProducto;
   v: array [1..100] of RProducto;
   p:fileOfProductos;
begin
  i:=1;
  assign(p,dirProductos);
  if archivoAbiertoProducto(p)<>0 then
     ShowMessage('Error')
  else
    begin
      while not eof(p) do
      begin
        read(p,producto);
        if(producto.id<>z.id)then
        begin
            v[i]:=producto;
            i:=i+1;
        end;
      end;
      close(p);
      if archivoAbiertoProducto2(p)<>0 then
       Close(p)
      else
          begin
            for j:=1 to i-1 do
            begin
              write(p,v[j]);
            end;
            close(p);
          end;

    end;
end;






{ADICIONALES}
function generarIdPedido():integer;
var
  f: fileOfPedidos;
  i:integer;
  aux:RPedido;
begin
     i:=0;
     assign(f,dirPedidos);  //asigno mi archi
     {$i-}reset(f);{$i+}
     if(IOResult<>0)then
      generarIdPedido:=1
     else
     begin
     read(f,aux);
     i:=aux.id+1;       // le asigno a i cuantos elementos tiene el archivo +1               // cierro el archivo
      close(f);
     generarIdPedido:=Random(100+i);
     end// mi id nuevo es el valor de i osea la cantidad de elementos más 1
end;

function generarIdProducto():integer;
var
  f: fileOfProductos;
  i:integer;
  aux:RProducto;
begin
     i:=0;
     assign(f,dirProductos);  //asigno mi archi
     {$i-}reset(f);{$i+}
     if(IOResult<>0)then
      generarIdProducto:=1
     else
     begin
     read(f,aux);
     i:=aux.id+1;       // le asigno a i cuantos elementos tiene el archivo +1               // cierro el archivo
      close(f);
     generarIdProducto:=Random(100+i);
     end// mi id nuevo es el valor de i osea la cantidad de elementos más 1
end;

function generarIdUser():integer;
var
  f: fileOfUsuarios;
  i:integer;
  aux:RUser;
begin
     assign(f,dirUsuarios);  //asigno mi archi
     reset(f);
     read(f,aux);
     i:=aux.id+1;       // le asigno a i cuantos elementos tiene el archivo +1
     close(f);              // cierro el archivo
     generarIdUser:= Random(100+i);     // mi id nuevo es el valor de i osea la cantidad de elementos más 1
end;

function generarIdCliente():integer;
var
  f: fileOfClientes;
  i:integer;
  aux:RCliente;
begin
     assign(f,dirClientes);  //asigno mi archi
     reset(f);
     read(f,aux);
     i:=aux.id+1;       // le asigno a i cuantos elementos tiene el archivo +1
     close(f);              // cierro el archivo
     generarIdCliente:= Random(100+i);     // mi id nuevo es el valor de i osea la cantidad de elementos más 1
end;

procedure CreaArchivoD();
var
  dt: RDetallePedido; f:fileOfDetallePedido;
begin
   dt.cantidad:=2;
   dt.id:=1;
   dt.numSerial:=21;
   dt.precioUnitario:=2;
   dt.producto.nombre:='Fanta';
   dt.subtotal:=212;
   assign(f,dirDetallePedidos);
   Rewrite(f);
   Write(f,dt);
   close(f);
end;

procedure CreaArchivo(var f: fileOfUsuarios);
var
  admin:RUser; producto:RProducto; p:fileOfProductos;
begin
  admin.id:=1;
  admin.dni:=12345678;
  admin.clave:='admin';
  admin.nombre:='Administrador Jose';
  admin.rol:='Administrador';
  Assign(f,'usuarios.dat');
  ReWrite(f);
  Write(f,admin);
  Close(f);


{Regitro de Gaseosas}
  Assign(p,'productos.dat');
  rewrite(p);
  producto.id:=1012;
  producto.dimension:=300;
  producto.nombre:='Fanta';
  producto.precio:=21;
  producto.stock:=2;
  write(p,producto);

  producto.id:= 1100      ;
  producto.nombre:= 'Sprite';
  producto.dimension:= 354;
  producto.precio:= 56;
  producto.stock:=  100 ;
  write(p,producto);

  producto.id:= 2301;
  producto.nombre:= 'Coca-Cola';
  producto.dimension:= 354;
  producto.precio:= 56 ;
  producto.stock:=  100;
  write(p,producto);

  producto.id:= 1451 ;
  producto.nombre:= 'Pasos de los Toros' ;
  producto.dimension:= 354;
  producto.precio:= 50 ;
  producto.stock:=  100;
  write(p,producto);
  close(p);
end;

procedure CreaArchivoC();
var
  cliente:RCliente;
  c: fileOfClientes;
begin
  cliente.id:=1;
  cliente.dni:=1;
  cliente.nombre:='Jose';
  cliente.domicilio:='centro';

  Assign(c,'clientes.dat');
  ReWrite(c);
  Write(c,cliente);
  Close(c);
end;

procedure CreaArchivoPed();
var
  pedido:RPedido;
  p: fileOfPedidos;
  v: RUser;
  f:fileOfUsuarios;
  cliente:RCliente;
  c:fileOfClientes;
begin
  assign(f,dirUsuarios);
  reset(f);
  while (not eof(f)) do
  begin
    read(f,v);
    if(v.rol='Vendedor')then
    seek(f,FileSize(f));
  end;
  close(f);
  pedido.vendedor:=v;
  assign(c,dirClientes);
  reset(c);
  while (not eof(c)) do
  begin
    read(c,cliente);
  end;
  close(c);
  pedido.cliente:=cliente;
  pedido.estado:='Cancelado';
  pedido.fecha:='22/11/2018';
  pedido.id:=1;
  pedido.impTotal:=22;
  Assign(p,dirPedidos);
  ReWrite(p);
  Write(p,pedido);
  Close(p);
end;



end.

