%%%-------------------------------------------------------------------
%%% File    : etanks_fun.erl
%%% Author  : Михаил Богатырев <ksupipr@yandex.ru>
%%% Description : Танчики 2. Сборник функций
%%%
%%% Created :  10 Aug 2012 by Михаил Богатырев <ksupipr@yandex.ru>
%%%-------------------------------------------------------------------
-module(etanks_fun).

-include_lib("xmerl/include/xmerl.hrl").

-export([parse_keyval/1, parse_keyval/2, parse_keyval/3, md5_hex/1, sendQuery/2, getAttr/2, getAtributes/2, get_sn_prefix/1, get_sn_id/1,
        list_to_erl/1, binary_to_erl/1, alive/1, num_key_in_list/3
,bin_to_num/1
,num_in_list/2
,list_to_int/1
,make_doc_xml/1
,replace_str/3
,uri_decode/1
,wrap_cron_once/2
,wrap_cron_cancel/1
,get_all_chiters/0
]).

%%--------------------------------------------------------------------
%% @doc создаем xml с пустым прологом
%% @spec
%% @end
%%--------------------------------------------------------------------

make_doc_xml(Data) ->
% Data = {myNode,[{foo,"Foo"},{bar,"Bar"}], [{node,[],[]}]}

    Xml = xmerl:export_simple([Data], xmerl_xml,[{prolog,[]}])
        ,lists:flatten(Xml).
  %  ,unicode:characters_to_binary(Xml).

%%--------------------------------------------------------------------
%% @doc парсит пары ключь=значение;  ключь=значение , где = и ; разделители значений и пар соответственно.
%% @spec parse_keyval(List1) -> [{key, value}|_]
%% @     parse_keyval(List1, KR) -> [{key, value}|_]
%% @     parse_keyval(List1, KR, KVR) -> [{key, value}|_]
%% @     где KR - разделитель пары ключь-значение, KVR - разделитель пар
%% @end
%%--------------------------------------------------------------------

parse_keyval(Bin)  when is_binary(Bin) ->
    parse_keyval(binary_to_list(Bin), "=", "; ");

parse_keyval(List) when is_list(List) ->
    parse_keyval(List, "=", "; ").

parse_keyval(Bin, KR)  when is_binary(Bin) ->
    parse_keyval(binary_to_list(Bin), KR, "; ");

parse_keyval(List, KR) when is_list(List) ->
    parse_keyval(List, KR, "; ").

parse_keyval(Bin, KR, KVR)  when is_binary(Bin) ->
    parse_keyval(binary_to_list(Bin), KR, KVR);

parse_keyval(List, KR, KVR) when is_list(List) ->
    KVMake = fun(KVStr) -> 
                KeyList = string:tokens(KVStr, KR),
                if (KeyList =/= [])  ->
                    [KeyIn|KeyList2] = KeyList,  
                    if (KeyList2 =/=[]) ->
                            [ValIn|_KeyList3] = KeyList2,
                            {KeyIn, ValIn};
                        true -> {KeyIn, []}
                    end;
                true -> []
                end
    end,
    case List of
        [] -> List;
         _ -> [KVMake(KVStr) || KVStr <- string:tokens(List, KVR)]
    end
.
%%--------------------------------------------------------------------
%% @doc бинарную строку <<"100">> в число 100
%% @spec bin_to_num(Bin) -> integer()|float()
%% @end
%%--------------------------------------------------------------------
bin_to_num(undefined) -> 0;
bin_to_num(Bin) ->
    N = binary_to_list(Bin),
    case string:to_float(N) of
        {error,no_float} -> list_to_integer(N);
        {F,_Rest} -> F 
    end.

%%--------------------------------------------------------------------
%% @doc md5 
%% @spec md5_hex(List) -> List2
%% @end
%%--------------------------------------------------------------------

md5_hex(S) ->
    Md5_bin =  erlang:md5(S),
    Md5_list = binary_to_list(Md5_bin),
    lists:flatten(list_to_hex(Md5_list)).

list_to_hex(L) ->
    lists:map(fun(X) -> int_to_hex(X) end, L).

int_to_hex(N) when N < 256 ->
    [hex(N div 16), hex(N rem 16)].

hex(N) when N < 10 ->
    $0+N;
hex(N) when N >= 10, N < 16 ->
    $a + (N-10).



sendQuery(RequestId, Data) ->
    Pid=gproc:lookup_local_name(<<"efcgi_client_fcgi">>),
    case (is_pid(Pid)) of
        true  ->
            gen_server:cast(Pid, {sendQuery, RequestId, Data});
            _ -> error
    end
.




getAtributes(XmlQ, Xpath) when is_binary(Xpath) ->
    getAtributes(XmlQ, binary_to_list(Xpath));

getAtributes(XmlQ, Xpath) when is_list(Xpath) ->
    Query = xmerl_xpath:string(lists:flatten(["//", Xpath]), XmlQ),
    [#xmlElement{ attributes = QueryA }] = Query,
    lists:foldl(fun(A, AccIn) -> attr(A, AccIn) end, [], QueryA)
;

getAtributes(_XmlQ, _Xpath) ->
[].


attr(A, AccIn) ->
    case A of 
        M when is_record(M, xmlAttribute) -> 
                                            if (is_atom(A#xmlAttribute.name)) -> Name = atom_to_list(A#xmlAttribute.name);
                                                                         true -> Name = A#xmlAttribute.name
                                            end,
                                            lists:flatten([AccIn ,[{Name, A#xmlAttribute.value}]]);
                    _ -> AccIn
    end
.

%%--------------------------------------------------------------------
%% @doc получает значение из [{key,val}] -> val
%% @spec getAttr(Key, Atributes) -> tuple()
%% @end
%%--------------------------------------------------------------------
getAttr(Key, Atributes) ->
     case (lists:keysearch(Key, 1, Atributes)) of
        {value, Vall} -> {_K, V} = Vall,
                         V;
                    _ -> err
    end
.


num_key_in_list(Key, Num, List) ->
    num_key_in_list(Key, Num, List, 0).

num_key_in_list(Key, Num, List, Now) ->
    case (lists:keytake(Key, Num, List)) of
            {value, _Tuple, List2} -> num_key_in_list(Key, Num, List2, Now+1);
            _ -> Now
    end.




num_in_list(Tuple, List) ->
    YON = fun (El) ->
            if (El==Tuple) -> false;
                      true -> true
            end
    end,
    length(List)-length(lists:filter(YON, List))
.

get_sn_prefix(Uid) ->
case (Uid) of
    M when is_list(M) -> Uid_in = M;
    W when is_binary(W) -> Uid_in = binary_to_list(W);
               _ -> Uid_in = "er_0"
end,

    [Pref1, Pref2|_T]= Uid_in,
    Pref = list_to_binary([Pref1, Pref2]),
    Pref.

get_sn_id(Uid) ->
case (Uid) of
    M when is_list(M) -> Uid_in = M;
    W when is_binary(W) -> Uid_in = binary_to_list(W);
               _ -> Uid_in = "er_0"
end,

    [_Pref1, _Pref2, _T|ST]= Uid_in,
    ST.

list_to_erl(Value) ->
{ok,Tokens,_} = erl_scan:string(lists:flatten([Value, "."])),
{ok,Term} = erl_parse:parse_term(Tokens),
Term
.

binary_to_erl(Value) ->
{ok,Tokens,_} = erl_scan:string(lists:flatten([binary_to_list(Value), "."])),
{ok,Term} = erl_parse:parse_term(Tokens),
Term
.

alive(A) when is_pid(A) -> is_process_alive(A);
alive(_A) -> false.




list_to_int(A) when is_binary(A) ->
    list_to_int(binary_to_list(A));
list_to_int(A) when is_list(A) ->
    list_to_integer(A);
list_to_int(A) when is_integer(A) ->
    A;
list_to_int(A) when is_float(A) ->
    trunc(A);
list_to_int(_A) ->
    error.

replace_str(String, First, ReChar) ->
    RList = string:tokens(String, First),
    string:join(RList, ReChar).


uri_decode(Uri) ->
    Udecode = http_uri:decode(Uri),
    replace_str(Udecode, "+", " ").


%%--------------------------------------------------------------------
%% @doc функция для создания сообщения(запуска функции) через указанное время 
%% @spec wrap_cron_once(Interval_sec, {M, F, A}) -> {ok,Tref}
%% @end
%%--------------------------------------------------------------------
wrap_cron_once(Interval_sec, {M, F, A}) ->
%% {ok,A} = timer:apply_after(3000, timer, send_after, [3000,self(),ok]), 
%% timer:cancel(A). 

    %%?INFO_MSG("Interval_sec : ~p~n", [Interval_sec*1000]),
    
timer:apply_after(Interval_sec*1000, M, F, A).
%%--------------------------------------------------------------------
%% @doc Отменяет задачу запускаемую по таймеру
%% @spec wrap_cron_cancel(A) -> {ok,canceled}
%% @end
%%--------------------------------------------------------------------
wrap_cron_cancel(A) ->
%%    ?INFO_MSG("wrap_cron_cancel   : ~p  ~n", [catch erlang:error(foobar)]),     
timer:cancel(A). 
%%--------------------------------------------------------------------
%% @doc функция которая определяет читеров с покупкой не в должное время кредитов
%% @spec
%% @end
%%--------------------------------------------------------------------
get_all_chiters()->
 Control_datatime = {{2012,12,14},{0,0,0}},
 {Days,_}=calendar:time_difference(Control_datatime,calendar:local_time()),
%lists:keystore(Key, 1, TupleList1, NewTuple)
           Cfun = fun(Num,X) ->
                               Query = io_lib:format("select distinct id_u from stat_sn_val where  type>1000 and type<2000 and date > TIMESTAMP '2012-12-14 02:55:00+05' + interval '~p day'  and date < TIMESTAMP '2012-12-14 04:55:59+05' + interval '~p day' ;",[X,X]),
                          List = xlab_db:equery(Num,  Query,[]), %[{id_u}...]
                           Query1= io_lib:format("select ~p,sn_id,id,(select name from tanks where tanks.id=users.id limit 1),link,(select sum( getted) from stat_sn_val where id_u=$1 and  type>1000 and type<2000 and  date < TIMESTAMP '2012-12-14 6:55:34.54133+05') from users where id=$1 and sn_id not like '-%' ;",[Num]),
                          L2 = [xlab_db:equery(Num,  Query1,[Id])||{Id}<-List],
                          [Id||[Id]<-L2]     %%{sn_id,id_u,name,link,in_val_count}
                         end,
All = [Cfun(N,X) || X <-lists:seq(0,Days),N <-lists:seq(1,5)] ,% {World_num, {sn_id,id_u,name,link,in_val_count}}


   
 Save_to_file = fun([],F)  ->
                       0;
               ({World_num, Sn_id,Id_u,Name,Link,In_val_count},F) -> 
           Moders_sn_id = [<<"8610402">>,<<"490804682383">>,<<"11756746109924451743">>,<<"11151288813489591416">>,<<"34419646907">>,<<"41954787426">>,<<"6180194">>,<<"56289618">>,<<"10463667466165377430">>,<<"3265540042973522830">>,<<"113469633296">>,<<"152733550">>,<<" 490804682383">>,<<"144207671">>,<<"170914474">>,<<"153530731003">>,<<"11718567905194732884">>,<<"134934738">>,<<"90840335359">>,<<"7807552337144180837">>,<<"173970579">>,<<"40681927975">>,<<"82590283">>,<<"93697865162">>,<<"94778766513">>,<<"272627242716">>,<<"152447560637">>,<<"150746104">>,<<"193527290931">>,<<" 5931092936726798194">>,<<"11756746109924451743">>,<<"119342890954">>,<<"170361396">>,<<"11501622179134047512">>,<<"40344538473">>,<<"121930798">>,<<"35807102">>,<<" 274772493938">>,<<"146669613">>,<<"174043969">>,<<"51921850">>,<<"149475576">>,<<"6650058724026771778">>,<<"8610402">>,<<"62614847">>,<<"14483768296719227879">>,<<"5903304">>,<<"340168167832">>,<<"151683110">>,<<"28962375">>,<<"164802513">>,<<"134513727">>],
                        Moder = case lists:member(Sn_id,Moders_sn_id) of
                                    true -> "!!moder!";
                                   _ ->                                    []
                                           end,
                        
                        case In_val_count of
                            null -> 
                                Del = io_lib:format("delete from users where sn_id = '~s' ;",[Sn_id]),
                                file:write_file( io_lib:format("/tmp/chit25jan ~p",[World_num]) ++ ".txt" , io_lib:fwrite("--delete from users where sn_id = '~p' ; -- ~p ~s ~p ~s \n", [Sn_id,In_val_count,Name,Link,Moder]),[append]),
                         xlab_db:equery(World_num, Del ,[]);
                            M  ->
                  file:write_file( io_lib:format("/tmp/chit25jan~p",[World_num]) ++ ".txt" , io_lib:fwrite(" delete from users where sn_id = '~p' ; -- ~p ~s ~p  ~s \n", [Sn_id,In_val_count,Name,Link,Moder]),[append])
                                    end
                           
                           ;
                  (D,F) when is_list(D) ->
                       [F(X1,F)|| X1 <- D]
               end,
[Save_to_file(X,Save_to_file)||X <-All].

			  
