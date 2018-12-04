unit formAltaProducto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons,unidadCentral,formPrincipal;

type

  { TfrmAltaProd }

  TfrmAltaProd = class(TForm)
    btnAceptar: TBitBtn;
    btnCancelar: TBitBtn;
    edt3: TEdit;
    edt5: TEdit;
    edt4: TLabeledEdit;
    edt1: TLabeledEdit;
    edt2: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnAceptarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
frmAltaProd: TfrmAltaProd;
p:fileOfProductos;

implementation



{$R *.lfm}


procedure cargarGrillaProductos;
var
    Aux:RProducto; i:integer;
    producto:fileOfProductos;
begin
   if(archivoAbiertoProducto(producto) <> 0) then // si se abrio dara un número distinto de 0 y empezamos a trabajar con el archivo en else
    Close(producto)
  else
  begin
       i:=1;
       frmPrincipal.grillaProductos.RowCount:=1;
       while not eof(producto) do //mientras tenga para leer el archivo y no encuentre en usuario
        begin
          frmPrincipal.grillaProductos.RowCount:=frmPrincipal.grillaProductos.RowCount+1;
          read(producto,Aux);                  // leo
          frmPrincipal.grillaProductos.Cells[0,i]:=IntToStr(Aux.id);
          frmPrincipal.grillaProductos.Cells[1,i]:=Aux.nombre;
          frmPrincipal.grillaProductos.Cells[2,i]:=IntToStr(Aux.dimension);
          frmPrincipal.grillaProductos.Cells[3,i]:=FloatToStr(Aux.precio);
          frmPrincipal.grillaProductos.Cells[4,i]:=IntToStr(Aux.stock);
          i:=i+1;
        end;
        close(producto);
  end;
end;

procedure borrar;

begin
   frmAltaProd.edt1.text:='';
   frmAltaProd.edt2.text:='';
   frmAltaProd.edt3.text:='';
   frmAltaProd.edt4.text:='';
   frmAltaProd.edt5.text:='';
end;

{ TfrmAltaProd }

procedure crearProducto(nuevo:RProducto);
var
   gaseosa:RProducto;i,j:integer;  v: Array [1..100] of RProducto;
begin
  i:=2;
       v[1]:=nuevo;
       if archivoAbiertoProducto(p)=0 then //abro archivo para lectura
       begin
            while not eof(p) do
            begin
                 read(p,gaseosa); //recorro y guardo en la variable USU
                 v[i]:=gaseosa;  //lo agrego al vector en la posición i
                 i:=i+1;     //aumento i para tener una siguiente posición en el vector
            end;
            close(p);
            if archivoAbiertoProducto2(p)<>0 then // veo que se pueda abrir el archivo para escritura '2 (dos'
               close(p)
            else
                //ordenarV(v,i);
                for j:=1 to i-1 do // recorro los elementos de mi arreglo
                begin
                     write(p,v[j]); //y los escribo en el archivo
                end;
                close(p);
       end
       else
           ShowMessage('problema');

end;

procedure TfrmAltaProd.btnAceptarClick(Sender: TObject);
Var
  newProduct: RProducto;
  mensaje:String;

begin
   {edt1.Text:=inttostr(generarIdCliente());}
   if (edt4.text<>'') and (edt2.text<>'') and (edt3.text<>'') and (edt4.text<>'') and (edt5.text<>'') then
   begin
         newProduct.nombre:=edt2.text;
         newProduct.dimension:=StrToInt(edt3.text);
         newProduct.precio:=StrToFloat(edt4.text);
         newProduct.stock:=StrToInt(edt5.text);

         if(frmAltaProd.Caption='AltaProducto')then
         begin
            newProduct.id:=StrToInt(edt1.text);
            borrar;
         end;

         if(frmAltaProd.Caption='ModificarProducto')then
         begin
            newProduct.id:=StrToInt(edt1.text);
            eliminarProducto(newProduct);
         end;

         crearProducto(newProduct);
         mensaje:='Creado/Modificado con exito, YES para continuar';

         if MessageDlg(mensaje, mtConfirmation,[mbYes], 0) = mrYes then

         begin
         cargarGrillaProductos;
         Close;
         end;
     end
   else
        ShowMessage('Por favor rellene todos los campos');

end;

procedure TfrmAltaProd.btnCancelarClick(Sender: TObject);
begin
  close;
end;

procedure TfrmAltaProd.FormCreate(Sender: TObject);
begin
    cargarGrillaProductos;
end;



end.

