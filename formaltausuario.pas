unit formAltaUsuario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, unidadCentral;

type

  { TfrmAltaUsuario }

  TfrmAltaUsuario = class(TForm)
    botonAceptar: TBitBtn;
    botonCancelar: TBitBtn;
    cbCategoria: TComboBox;
    editDni: TEdit;
    editClave: TLabeledEdit;
    editClave2: TLabeledEdit;
    editId: TLabeledEdit;
    editNombre: TLabeledEdit;
    Label1: TLabel;
    errorDNI: TLabel;
    Label2: TLabel;
    procedure botonAceptarClick(Sender: TObject);
    procedure botonCancelarClick(Sender: TObject);
    {procedure editDniChange(Sender: TObject);}
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  frmAltaUsuario: TfrmAltaUsuario;

  f:fileOfUsuarios; aux:fileOfUsuarios;
implementation
         uses formPrincipal;
{$R *.lfm}

function camposLlenos(cbCategoria: TComboBox;
    editClave: TLabeledEdit;
    editClave2: TLabeledEdit;
    editDni: TEdit;
    editNombre: TLabeledEdit): boolean;
begin
  if(cbCategoria.Caption<>'SELECCIONAR') and (editClave.Text<> '')
  and (editClave2.Text<>'') and (editDni.Text<>'') and (editNombre.Text<>'') then
  camposLlenos:=true
  else
    camposLlenos:=false;
end;

procedure ordenarV(var v: Array of RUser; n:integer);
Var
 Done: Boolean;
 Jump,
 I,
 J : Integer;
 aux: RUser;
 Begin
 Jump := n;
 While (Jump < 1) Do
 Begin
 Jump := Jump Div 2;
 Repeat
 Done := true;
 For J := 1 To (N - Jump) Do
 Begin
 I := J + Jump;
 If (V[J].id < V[I].id) Then
 Begin
 aux := V[I];
 V[I] := V[ J ] ;
 V[ J] := aux;
 Done := false
 End;
 End;
 Until Done;
 End
 End;

procedure crearUsuario(nuevo: RUser);
var
   usu:RUser;i,j:integer;  v: Array [1..100] of RUser;
begin
  i:=2;
       v[1]:=nuevo;
       if archivoAbiertoUsers(f)=0 then //abro archivo para lectura
       begin
            while not eof(f) do
            begin
                 read(f,usu); //recorro y guardo en la variable USU
                 v[i]:=usu;  //lo agrego al vector en la posición i
                 i:=i+1;     //aumento i para tener una siguiente posición en el vector
            end;
            close(f);
            if archivoAbiertoUsers2(f)<>0 then // veo que se pueda abrir el archivo para escritura '2 (dos'
               close(f)
            else
                //ordenarV(v,i);
                for j:=1 to i-1 do // recorro los elementos de mi arreglo
                begin
                     write(f,v[j]); //y los escribo en el archivo
                end;
                close(f);
       end
       else
           ShowMessage('problema');


end;

procedure borrar();
begin
    frmAltaUsuario.editid.text:='';
    frmAltaUsuario.editDni.text:='';
    frmAltaUsuario.editClave.text:='';
    frmAltaUsuario.editClave2.text:='';
    frmAltaUsuario.editNombre.text:='';
    frmAltaUsuario.cbCategoria.text:='SELECCIONE';
end;

{ TfrmAltaUsuario }

procedure TfrmAltaUsuario.botonAceptarClick(Sender: TObject);
var
  newUser: RUser;
  mensaje:String;
begin

   if(camposLlenos(cbCategoria,editClave,editClave2,editDni,editNombre))then
   begin
     if(editClave.Text=editClave2.Text)then
     begin
         newUser.nombre:=editNombre.Text;
         newUser.dni:=StrToInt(editDni.Text);
         newUser.clave:=editClave2.Text;
         newUser.rol:=cbCategoria.Text;

         if(frmAltaUsuario.Caption='AltaUsuario')then
         newUser.id:=generarIdUser();

         if(frmAltaUsuario.Caption='ModificarUsuario')then
         begin
              newUser.id:=strtoint(editId.Text);
              eliminarUsuario(newUser);
         end;
         crearUsuario(newUser);
         frmPrincipal.botonBuscarClick(Sender);
         mensaje:='Usuario creado con exito YES para continuar';
         if MessageDlg(mensaje, mtConfirmation,[mbYes], 0) = mrYes then
         begin
         borrar();
         Close;
         end;
     end
     else
         ShowMessage('Las contraseñas no son iguales');

   end
   else
   ShowMessage('Por favor rellene todos los campos');
end;

procedure TfrmAltaUsuario.botonCancelarClick(Sender: TObject);
begin
  close;
  borrar();
end;

{procedure TfrmAltaUsuario.editDniChange(Sender: TObject);
var
 dni:integer;      {Mensaje de Error de Invalidacion}
begin
if (ErrorDNI.Caption='DNI invalid') or (ErrorDNI.caption='DNI Valid') then
ErrorDNI.Caption:='';
 val(editDNI.text,dni);

  if (DNI<99000000) and (DNI>1000000)  then
  begin
    ErrorDNI.caption:='DNI valid';
    errorDNI.Font.Color:=clGreen;
  end
  else
  begin
    ErrorDNI.caption:='DNI invalid';
    errorDNI.Font.Color:=clRed;
  end;
end;  }

procedure TfrmAltaUsuario.FormActivate(Sender: TObject);
begin
  if(frmAltaUsuario.Caption='AltaUsuario')then
  editId.text:= IntToStr(generarIdUser);
end;

end.

