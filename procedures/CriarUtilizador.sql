CREATE OR REPLACE FUNCTION registerUser(p_nome text, p_email text, p_password text) returns bigint
LANGUAGE plpgsql
AS $BODY$
declare
	cursorEmail cursor(newEmail pessoa.email%type) for
		select email
		from pessoa
		where email=newEmail;
	cursorNome cursor(newNome pessoa.nome%type) for
		select nome
		from pessoa
		where nome=newNome;
	resEmail pessoa.email%type;
	resNome pessoa.nome%type;
	id  pessoa.id%type;
begin
	--check if email already exists
	open cursorEmail(p_email);
	fetch cursorEmail into resEmail;
	if(found) THEN
		close cursorEmail;
		return null;
	end if;
	--check if nome already exists
	open cursorNome(p_nome);
	fetch cursorNome into resNome;
	if(found) THEN
		close cursorNome;
		return null;
	end if;
	--insert new pessoa and return new id
	insert into pessoa(nome,email,password)
	values(p_nome,p_email,p_password);
	select pessoa.id from pessoa where nome=p_nome into id;
	close cursorEmail;
	close cursorNome;
	return id;
end;
$BODY$;