unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.TextLayout, FMX.Edit;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    imgVoltar: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    Circle1: TCircle;
    Label2: TLabel;
    lvChat: TListView;
    Layout3: TLayout;
    imgFundo: TImage;
    StyleBook1: TStyleBook;
    btnEnviar: TSpeedButton;
    Image1: TImage;
    edtTexto: TEdit;
    procedure FormShow(Sender: TObject);
    procedure lvChatUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnEnviarClick(Sender: TObject);

  private
    procedure AddMessage(id_msg: integer; texto, dt: string;
      ind_propio: boolean);
    procedure ListarMensagens;
    procedure LayoutLv(item: TListViewItem);
    procedure LayoutLvPropio(item: TListViewItem);
    function GetTextHeight(const D: TListItemText; const Width: single;
      const Text: string): Integer;
    { Private declarations }

  public
    { Public declarations }

  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}
{$R *.Surface.fmx MSWINDOWS}

//Calcular responsividade CODIGO PROPRIO DA EMBARCADERO
function TFrmPrincipal.GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;

    Result := Round(Layout.Height);

    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

procedure TFrmPrincipal.LayoutLv(item: TListViewItem );
var
  img: TListItemImage;
  txt: TListItemText;
begin
  // Posiciona o texto...
  txt := TListItemText(item.Objects.FindDrawable('txtMsg'));
  txt.Width := lvChat.Width / 2 - 16;
  txt.PlaceOffset.X := 20;
  txt.PlaceOffset.Y := 10;
  txt.Height := GetTextHeight(txt, txt.Width, txt.Text);
  txt.TextColor := $FF000000;

  // Balao msg...
  img := TListItemImage(item.Objects.FindDrawable('imgFundo'));
  img.Width := lvChat.Width / 2;
  img.PlaceOffset.X := 10;
  img.PlaceOffset.Y := 10;
  img.Height := txt.Height;
  img.Opacity := 0.1;

  if txt.Height < 40 then
    img.Width := Trunc(txt.Text.Length * 9);

  // Data..
  txt := TListItemText(item.Objects.FindDrawable('txtData'));
  txt.PlaceOffset.X := img.PlaceOffset.X + img.Width - 100;
  txt.PlaceOffset.Y := img.PlaceOffset.Y + img.Height + 2;

  // Altura do item da Lv...
  item.Height := Trunc(img.PlaceOffset.Y + img.Height + 30);

end;

procedure TFrmPrincipal.LayoutLvPropio(item: TListViewItem );
var
  img: TListItemImage;
  txt: TListItemText;
begin
  // Posiciona o texto...
  txt := TListItemText(item.Objects.FindDrawable('txtMsg'));
  txt.Width := lvChat.Width / 2 - 16;
  txt.PlaceOffset.Y := 10;
  txt.Height := GetTextHeight(txt, txt.Width, txt.Text);
  txt.TextColor := $FFFFFFFF;

  // Balao msg...
  img := TListItemImage(item.Objects.FindDrawable('imgFundo'));

  if txt.Height < 40 then //MSG COM UMA LINHA
    img.Width := Trunc(txt.Text.Length * 9)
  else
    img.Width := lvChat.Width / 2;

  txt.PlaceOffset.X := lvChat.Width - img.Width;

  img.PlaceOffset.X := lvChat.Width - 10 - img.Width;
  img.PlaceOffset.Y := 10;
  img.Height := txt.Height;
  img.Opacity := 1;



  // Data..
  txt := TListItemText(item.Objects.FindDrawable('txtData'));
  txt.PlaceOffset.X := img.PlaceOffset.X + img.Width - 100;
  txt.PlaceOffset.Y := img.PlaceOffset.Y + img.Height + 2;

  // Altura do item da Lv...
  item.Height := Trunc(img.PlaceOffset.Y + img.Height + 30);

end;

procedure TFrmPrincipal.AddMessage(id_msg: integer;texto, dt: string;ind_propio: boolean);
var
  item: TListViewItem;
begin
  item := lvChat.Items.Add;

  with item do
  begin
    Height := 100;
    Tag := id_msg;

    if ind_propio then
      TagString := 'S'
    else
      TagString := 'N';

    // Fundo...
    TListItemImage(Objects.FindDrawable('imgFundo')).Bitmap := imgFundo.Bitmap;

    // Texto...
    TListItemText(Objects.FindDrawable('txtMsg')).Text := Texto;

    // Data...
    TListItemText(Objects.FindDrawable('txtData')).Text := dt;

    if ind_propio then
      LayoutLvPropio(item)
    else
      LayoutLv(item);

  end;
end;

procedure TFrmPrincipal.ListarMensagens;
begin
  addMessage(123, 'Oi....', '21:48h', false);
  addMessage(123, 'Ol�, em que posso ajudar? Dependendo do que � eu posso agora!', '21:48h', true);
  addMessage(123, 'Tudo bem? Gostaria de lhe pedir um favor seu...', '21:49h', false);
  addMessage(123, '.....', '22:01h', false);
end;

procedure TFrmPrincipal.lvChatUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if AItem.TagString = 'S' then
    LayoutLvPropio(AItem)
  else
    LayoutLv(AItem);
end;

procedure TFrmPrincipal.btnEnviarClick(Sender: TObject);
begin
 AddMessage(1212, edtTexto.Text, FormatDateTime('dd/mm/yy hh:nn', date), true);
 lvChat.ScrollTo(lvChat.Items.Count - 1);
 edtTexto.Text := '';
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  ListarMensagens;
end;


end.
