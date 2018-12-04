unit formLogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, unidadCentral, ExtCtrls, Buttons;

type
  { TfrmLogin }

  TfrmLogin = class(TForm)
    btnLogin: TBitBtn;
    editClave: TEdit;
    editUser: TEdit;
    fondo: TImage;
    lbError: TLabel;
    lblSalir: TLabel;
    procedure btnLoginClick(Sender: TObject);
    procedure lblSalirClick(Sender: TObject);
  private

  public

  end;

var
  frmLogin: TfrmLogin;
  fOfUsers: fileOfUsuarios;
  lbUsu,lbCargo: cad;
implementation

uses formPrincipal,formAltaPedidos;

{$R *.lfm}

{ TfrmLogin }
function login(s: integer; c:cad):LongInt;
var
  userAux:RUser;
  band:LongInt;
begin
  band:=-1; // inicializo una bandera para terminar el while en caso encuentre al usuario
  if(archivoAbiertoUsers(fOfUsers)<> 0) then // si se abrio dara un número distinto de 0 y empezamos a trabajar con el archivo en else
    Close(fOfUsers)
  else
  begin
       while (not eof(fOfUsers)) and (band=-1) do //mientras tenga para leer el archivo y no encuentre en usuario
        begin
          //detalle pedido clave foreana pedido
          read(fOfUsers,userAux);                  // leo
          if (userAux.dni=s) and (userAux.clave=c)then //veo sí algun usuario es igual a los de los edit
          begin
               lbUsu:=userAux.nombre;
               lbCargo:=userAux.rol;
               band:=FilePos(fOfUsers);
               frmLogin.Visible:=false;                  //devuelvo la posición en el que encontre a mi usuario
          end;
        end;
        close(fOfUsers);
  end;

  login:=band; //devuelvo mi band <>-1 sí encontre un usuario, -1 si no.

end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  pos,usuario: integer;
  clave: cad;
begin
     //CreaArchivo(fOfUsers);
    //CreaArchivoD();
    //CreaArchivoC();
  //CreaArchivoPed();
     if( editUser.Text<>'') and (editClave.Text<>'')then
     begin
           usuario:= StrToInt(editUser.Text);
           clave:=editClave.Text;
           pos:= login(usuario,clave);  //pos toma la posición del usuario que encontre en el archivo en caso contrario(osea que no hay un usuario con los datos del edit) devuelve -1
        if(pos<>-1) then
           //abrirFormGestion(pos)
        begin
        frmPrincipal.botonBuscarClick(Sender);
        frmPrincipal.lbUser.Caption:=lbUsu;
        frmPrincipal.lbUser1.Caption:=lbUsu;
        frmPrincipal.lbUser2.Caption:=lbUsu;
        frmAltaPedidos.lbUser3.Caption:=lbUsu;
        frmPrincipal.lbUser4.Caption:=lbUsu;
        frmPrincipal.lbCargo.Caption:=lbCargo;
        frmPrincipal.lbCargo1.Caption:=lbCargo;
        frmPrincipal.lbCargo2.Caption:=lbCargo;
        frmPrincipal.lbCargo3.Caption:=lbCargo;
        frmPrincipal.botonPedido.Visible:=true;
        frmPrincipal.cbPedVendedores.Visible:=false;
        frmAltaPedidos.lbCargo3.Caption:=lbCargo;
        if(lbCargo='Vendedor')then
        begin
          frmPrincipal.pagPrincipal.ShowTabs:=false;
          frmPrincipal.pagPrincipal.TabIndex:=3;
          frmPrincipal.botonNuevo1.Visible:=true;
          frmPrincipal.botonConfirmar.Visible:=true;
          frmPrincipal.botonCancelar.Visible:=true;
          frmPrincipal.cbPedVendedores.Visible:=false;
          frmPrincipal.botonPedido.Visible:=false;
          frmPrincipal.buscarClick(Sender);
        end
        else
        begin
          frmPrincipal.pagPrincipal.ShowTabs:=true;
          frmPrincipal.pagPrincipal.TabIndex:=0;
          frmPrincipal.botonNuevo1.Visible:=false;
          frmPrincipal.botonConfirmar.Visible:=false;
          frmPrincipal.botonCancelar.Visible:=false;
          frmPrincipal.cbPedVendedores.Visible:=true;
          frmPrincipal.buscarClick(Sender);
        end;
        frmPrincipal.Show;
        editClave.Text:='';
        editUser.Text:='';
        //frmPrincipal.PagPrincipal.TabIndex:=1;
        end
          else
      //MessageDlg ('Ingreso no valido','Usuario o Contraseña Incorrecto' ,mtWarning, [mbYes], 0)
        lbError.Caption:='Usuario o Contraseña incorrecta';
      end
      else
      MessageDlg ('Datos incompletos','Por favor rellene todos los campos' ,mtWarning, [mbYes], 0);

end;

procedure TfrmLogin.lblSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;


end.

