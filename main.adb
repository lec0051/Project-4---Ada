with Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO, Random;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;

procedure Main is
	type BINARY_NUMBER is range 0 .. 1;
	type BINARY_ARRAY is array (1 .. 16) of BINARY_NUMBER;

	My_Array : BINARY_ARRAY;
	Another_Array : BINARY_ARRAY;
	Array3 : BINARY_ARRAY;
	Array4 : BINARY_ARRAY;

	package My_Random is new Random (FLOAT);
	use My_Random;

	function Bin_To_Int (A: BINARY_ARRAY) return Integer is
	Exponent : INTEGER := 0;
	Result : INTEGER := 0;
	begin
		for I in reverse A'Range loop
			Result := Result + (INTEGER(A(I)) * 2**Exponent);
			Exponent := Exponent + 1;
		end loop;
		return Result;
	end Bin_To_Int;

	function Int_To_Bin (A: Integer) return BINARY_ARRAY is
	Result : BINARY_ARRAY := (0,0,0,00,0,0,0,0,0,0,0,0,0,0,0);
	B : Integer := A;
	begin
		for I in reverse Result'Range loop
			if (B mod 2 = 0) then
				Result(I) := 0;
				B := B / 2;
			else
				Result(I) := 1;
				B := (B - 1) / 2;
			end if;
		end loop;
		return Result;
	end Int_To_Bin;

	function "+" (A, B : BINARY_ARRAY) return BINARY_ARRAY is
	Result : BINARY_ARRAY := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
	Current_Sum : Integer;
	Carry : Integer := 0;
	begin
		for I in reverse A'Range loop
			Current_Sum := INTEGER(A(I)) + INTEGER(B(I)) + Carry;
			if (Current_Sum mod 2 = 0) then
				Result(I) := 0;
			else 
				Result(I) := 1;
			end if;
			if (Current_Sum > 1) then 
				Carry := 1;
			else
				Carry := 0;
			end if;
		end loop;
		return Result;
	end "+";

	function "+" (A : BINARY_ARRAY; B : Integer) return BINARY_ARRAY is
	B_Arr : BINARY_ARRAY := Int_To_Bin(B);
	Result : BINARY_ARRAY := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
	Current_Sum : Integer;
	Carry : Integer := 0;
	begin
		for I in reverse A'Range loop
			Current_Sum := INTEGER(A(I)) + INTEGER(B_Arr(I)) + Carry;
			if (Current_Sum mod 2 = 0) then
				Result(I) := 0;
			else
				Result(I) := 1;
			end if;
			if (Current_Sum > 1) then
				Carry := 1;
			else 
				Carry := 0;
			end if;
		end loop;
		return Result;
	end "+";

	function "-" (A, B : BINARY_ARRAY) return BINARY_ARRAY is
	A_New : BINARY_ARRAY := A;
	Result : BINARY_ARRAY := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
	Subtraction : Integer;
	Check_Index : Integer;
	begin
		for I in reverse A_New'Range loop
			Subtraction := INTEGER(A_New(I)) - INTEGER(B(I));
			Check_Index := I;
			if (Subtraction < 0) then
				while ((Check_Index /= 0) and (A_New(Check_Index) = 0)) loop
					A_New(Check_Index) := 1;
					Check_Index := Check_Index - 1;
				end loop;
				A_New(Check_Index) := 0;
				Result(I) := 1;
			else
				if (A_New(I) = B(I)) then 
					Result(I) := 0;
				else 
					Result(I) := 1;
				end if;
			end if;
		end loop;
		return Result;
	end "-";

	function "-" (A : BINARY_ARRAY; B : Integer) return BINARY_ARRAY is
	A_New : BINARY_ARRAY := A;
	B_New : BINARY_ARRAY := Int_To_Bin(B);
	Result : BINARY_ARRAY := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
	Subtraction : Integer;
	Check_Index : Integer;
	begin
		for I in reverse A_New'Range loop
			Subtraction := INTEGER(A_New(I)) - INTEGER(B_New(I));
			Check_Index := I;
			if (Subtraction < 0) then
				while ((Check_Index /= 0) and (A_New(Check_Index) = 0)) loop
					A_New(Check_Index) := 1;
					Check_Index := Check_Index - 1;
				end loop;
				A_New(Check_Index) := 0;
				Result(I) := 1;
			else 
				if (A_New(I) = B_New(I)) then
					Result(I) := 0;
				else
					Result(I) := 1;
				end if;
			end if;
		end loop;
		return Result;
	end "-";

	procedure Reverse_Bin_Arr (A: in out BINARY_ARRAY) is
	StartIndex : INTEGER := 1;
	EndIndex : INTEGER := 16;
	Placeholder : BINARY_NUMBER;
	begin
		while StartIndex < EndIndex loop
			Placeholder := A(EndIndex);
			A(EndIndex) := A(StartIndex);
			A(StartIndex) := Placeholder;
			StartIndex := StartIndex + 1;
			EndIndex := EndIndex - 1;
		end loop;
	end Reverse_Bin_Arr;

	procedure Print_Bin_Arr (A: BINARY_ARRAY) is
	Array_Element : INTEGER;
	begin
	for I in A'Range loop
		Array_Element := INTEGER(A(I));
		Put(Array_Element, 1);
	end loop;
	end Print_Bin_Arr;

begin
	Set_Seed;
	for I in My_Array'Range loop
		My_Array(I) := BINARY_NUMBER((INTEGER(FLOAT(Random_Number) * FLOAT(10))) mod 2);
	end loop;

	Put("Printing Random Array My_Array");
	New_Line(1);
	Print_Bin_Arr(My_Array);
	New_Line(1);
	New_Line(1);
	Put("Printing Integer value of My_Array");
	New_Line(1);
	Put(Bin_To_Int(My_Array), 1);
	New_Line(1);
	New_Line(1);
	Put("Printing Array created from Int_To_Bin function: Int_To_Bin(55);");
	New_Line(1);
	Another_Array := Int_To_Bin(55);
	Print_Bin_Arr(Another_Array);
	New_Line(1);
	New_Line(1);
	Put("Printing value of My_Array + Another_Array, first + overload");
	New_Line(1);
	Put("Int value of My_Array: ");
	Put(Bin_To_Int(My_Array), 1);
	New_Line(1);
	Put("Int value of Another_Array: ");
	Put(Bin_To_Int(Another_Array), 1);
	New_Line(1);
	Array3 := My_Array + Another_Array;
	Put("Int value of Array3: ");
	Put(Bin_To_Int(Array3), 1);
	New_Line(1);
	Put("Binary value of Array3: ");
	Print_Bin_Arr(Array3);
	New_Line(1);
	New_Line(1);
	Put("Printing value of Array3 + Int_To_Bin(10), second + overload");
	New_Line(1);
	Put("Int value of Array3 after addition: ");
	Array3 := Array3 + 10;
	Put(Bin_To_Int(Array3), 1);
	New_Line(1);
	Put("Current binary value of Array3: ");
	Print_Bin_Arr(Array3);
	New_Line(1);
	New_Line(1);
	Put("Printing value of My_Array - Another_Array, first - overload");
	New_Line(1);
	Array4 := My_Array - Another_Array;
	Put("Int value of My_Array: ");
	Put(Bin_To_Int(My_Array), 1);
	New_Line(1);
	Put("Int value of Another_Array: ");
	Put(Bin_To_Int(Another_Array), 1);
	New_Line(1);
	Put("Int value of Array4: ");
	Put(Bin_To_Int(Array4), 1);
	New_Line(1);
	Put("Binary value of Array4: ");
	Print_Bin_Arr(Array4);
	New_Line(1);
	New_Line(1);
	Put("Printing value of My_Array - Int_To_Bin(50), second - overload");
	New_Line(1);
	Put("Int value of My_Array: ");
	Put(Bin_To_Int(My_Array), 1);
	New_Line(1);
	Put("Int value of Array4 after modification: ");
	Array4 := My_Array - 50;
	Put(Bin_To_Int(Array4), 1);
	New_Line(1);
	Put("Binary value of Array4: ");
	Print_Bin_Arr(Array4);
	New_Line(1);
	New_Line(1);
	Put("Reversing and printing Array4");
	New_Line(1);
	Reverse_Bin_Arr(Array4);
	Print_Bin_Arr(Array4);
end Main;













