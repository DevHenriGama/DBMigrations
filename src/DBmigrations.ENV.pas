unit DBmigrations.ENV;

interface

function _ENV: string;

implementation

function _ENV: string;
begin
  Result := 'prod';
end;

end.
