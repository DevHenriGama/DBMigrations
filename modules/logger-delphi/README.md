# 🌟 Logger-Delphi

Logger-Delphi é um poderoso componente para Delphi projetado para facilitar a criação e gerenciamento de logs dentro de uma aplicação.

## 🚀 Recursos
✅ Registro de logs personalizados
✅ Suporte para diferentes tipos de logs
✅ Possibilidade de associar logs a usuários
✅ Integração simples com aplicações Delphi

---

## 🔧 Instalação
### 📥 Instalação Manual
1. Baixe o repositório do Logger-Delphi.
2. Adicione o caminho do componente ao seu projeto no Delphi.
3. Inclua a unidade do Logger no seu código.

### ⚡ Instalação via Boss
Se você utiliza o [Boss](https://github.com/HashLoad/boss), pode instalar o Logger-Delphi facilmente com o seguinte comando:
```sh
boss install https://github.com/DevHenriGama/Logger-Delphi.git
```

---

## 📌 Exemplo de Uso

```delphi
procedure TfrmLog.Button1Click(Sender: TObject);
var
  FTeste: String;
begin
  FTeste := edtLogText.Text + sLineBreak + edtLogText.Text;

  if not CheckBox1.Checked then
    Log.Add(FTeste, FType, edtUser.Text)
  else
    cLog(edtLogName.Text).Add(FTeste, FType, edtUser.Text);
end;
```

---

## 🤝 Contribuição
Contribuições são bem-vindas! Para contribuir:
1. 🍴 Faça um fork do repositório.
2. 🌿 Crie um branch para a sua feature (`git checkout -b minha-feature`).
3. 💾 Faça commit das suas alterações (`git commit -m 'Adicionando minha feature'`).
4. 🚀 Faça push do branch (`git push origin minha-feature`).
5. 🔁 Abra um Pull Request.

---

## 📜 Licença
Este projeto é distribuído sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

✨ **Feito com 💙 para a comunidade Delphi!**

