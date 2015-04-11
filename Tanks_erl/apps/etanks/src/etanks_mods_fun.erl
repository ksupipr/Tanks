%%%-------------------------------------------------------------------
%%% File    : etanks_mods_fun.erl
%%% Author  : Михаил Богатырев <ksupipr@yandex.ru>
%%% Description : Танчики 2. Функции работы с модами
%%%
%%% Created :  30 Aug 2012 by Михаил Богатырев <ksupipr@yandex.ru>
%%%-------------------------------------------------------------------
-module(etanks_mods_fun).


-export([parse_str_mods/1, parse_hstore/1, marge_qn_list/2, marge_qn_list/3, marge_qn/2, marge_qn/3, default_num_raz/1]).

%%--------------------------------------------------------------------
%% @doc парсер модов текстовый.
%%      List1 вида "{{0,0}, {2,0}, {30,1}}"
%%     где {откуда, куда, что} => {{раздел, слот}, {раздел, слот}, {вещь, количество}}
%% @spec parse_str_mods(List1) -> {{0,0}, {2,0}, {30,1}}
%% @end
%%--------------------------------------------------------------------

parse_str_mods(Bin)  when is_binary(Bin) ->
    parse_str_mods(binary_to_list(Bin));

parse_str_mods(List) when is_list(List) ->
%{{0,0}, {2,0}, {30,1}}"
% откуда, куда, что

    if (List==[]) -> {{0,0}, {0,0}, {0,0}};
        true ->  Term_out = etanks_fun:list_to_erl(List),
                 case (Term_out) of
                        {{A,B}}                     -> {{list_to_int(A),list_to_int(B)}, {0,0}, {0,0}};
                        {{A1,B1}, {C1,D1}}          -> {{list_to_int(A1),list_to_int(B1)}, {list_to_int(C1),list_to_int(D1)}, {0,0}};
                        {{A2,B2}, {C2,D2}, {E2,F2}} -> {{list_to_int(A2),list_to_int(B2)}, {list_to_int(C2),list_to_int(D2)}, {list_to_int(E2),list_to_int(F2)}};
                                                  _ -> {{0,0}, {0,0}, {0,0}}
                 end
    end
.

list_to_int(A) ->
    etanks_fun:list_to_int(A).

parse_hstore(Bin) when is_binary(Bin) ->
    parse_hstore(binary_to_list(Bin));

parse_hstore(Bin) ->
    if (Bin =/= null) ->
                List = etanks_fun:parse_keyval(Bin, "=>", ", ");
        true -> List = []
    end,
    INTL = fun (T) ->
        {K1, K2} = T,
        {list_to_integer(string:substr(K1, 2, (string:len(K1)-2))), list_to_integer(string:substr(K2, 2, (string:len(K2)-2)))}
    end,
    [INTL(T) || T <- List]
.

marge_qn_list(Snum, List1) ->
    marge_qn_list(Snum, List1, [])
.

marge_qn_list(Snum, List1, List2) ->

IntFor = lists:seq(1, Snum),
            
MargeQn = fun(A, AccIn) ->
    case (A) of
        [] -> AccIn;
         _ -> 
                K1 = etanks_fun:getAttr(A, List1),

                K2 = etanks_fun:getAttr(A, List2),

                if (K1==err) -> K1_in =0; true -> K1_in = K1 end,
                if (K2==err) -> if (K1_in==0) -> K2_in =0; 
                                         true -> K2_in =1
                                end;
                true -> K2_in = K2 end,
                lists:flatten([AccIn, [{K1_in, K2_in}]])
    end
end,

lists:foldl(MargeQn, [], IntFor)
.

marge_qn(Raz, List1) ->
    marge_qn(Raz, List1, [])
.

marge_qn(Raz, List1, List2) ->

{Raz_num, Num_need} = Raz,


Snum_def = default_num_raz(Raz_num),

% получаем номер раздела и нужное количество, если нужного количества нет, то достаем его из списка, если и там нет, то делаем по умолчанию
if (Num_need =/= null) -> Snum = Num_need, List1_w = List1;
    true ->
            if (List1==[]) -> Num_from_list = 0;
                      true -> Num_from_list = lists:nth(1, List1)
            end,
            case (Num_from_list) of 
                {LF0, LF1} -> if ((LF0==0) and (LF1>=Snum_def)) ->
                                    Snum = LF1,
                                    List1_w = lists:nthtail(1, List1);
                                    true -> Snum = Snum_def, List1_w = List1
                              end;
                         _ -> Snum = Snum_def, List1_w = List1
            end
end,



IntFor = lists:seq(0, Snum-1),
            
%io:format("~n Snum: ~p~n~n", [Snum]),

% формируем массив значений, если список пустой, то заполняем пустыми значениями по умолчанию размерности по умолчанию
MargeQn = fun(A, AccIn) ->



    case (A) of
        [] -> AccIn;
         _ -> 
                K1 = etanks_fun:getAttr((A+1), List1_w),
                K2 = etanks_fun:getAttr((A+1), List2),

                if ((K1==err) or (K1<0)) -> K1_in = 0; true -> K1_in = K1 end,
                if ((K2==err) or (K2<0)) -> if (K1_in==0) -> K2_in =0; 
                                                     true -> K2_in =1
                                            end;
                true -> if (K1_in==0) -> K2_in =0; 
                                         true -> K2_in = K2
                                end
                end,

                

%io:format("~n A: ~p {~p, ~p}~n", [A, K1_in, K2_in]),
                if (K1_in>0) and (K2_in>0) ->
                                                array:set(A, {K1_in, K2_in}, AccIn);
                                      true ->   array:set(A, {0, 0}, AccIn)
                end
    end
end,

lists:foldl(MargeQn, array:new([{size, Snum}, {default, {0, 0}}, {fixed, true}]), IntFor)
.

default_num_raz(Raz) ->
    case(Raz) of
        1 -> 24;
        2 -> 36;
        3 -> 5;
        4 -> 4;
        5 -> 4;
        6 -> 8;
        7 -> 6;
        _ -> 0
    end
.