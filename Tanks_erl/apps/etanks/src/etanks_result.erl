%%%-------------------------------------------------------------------
%%% File    : etanks_result.erl
%%% Author  : Михаил Богатырев <ksupipr@yandex.ru>
%%% Description : Танчики 2. Функции работы ответами
%%%
%%% Created :  16 Oct 2012 by Михаил Богатырев <ksupipr@yandex.ru>
%%%-------------------------------------------------------------------
-module(etanks_result).

-export([make_result/1]).

make_result(Result) ->
case Result of



{move_mods, MMCode1, MMDescr1, MMI1, Money_m1} -> R_out = make_result({move_mods, MMCode1, MMDescr1, MMI1, [], Money_m1, []});

{move_mods, MMCode2, MMDescr2, MMI2, MMIO2, Money_m2} -> R_out = make_result({move_mods, MMCode2, MMDescr2, MMI2, MMIO2, Money_m2, []});


{move_mods, MMCode, MMDescr, MMI, MMIO, Money_m, XML_in} ->
% ответ на перенос модов 

%io:format("MMI: ~p ~n~n ", [MMI]),
%io:format("MMIO: ~p ~n~n ", [MMIO]),


    Q1 = lists:flatten(["<err code=\"", integer_to_list(MMCode), "\" comm=\"", MMDescr ,"\" >"]),
    
    MMI_fun = fun(A, AccIn) ->
        case A of
            {{From_r, From_s}, {To_r, To_s}, {M_id, M_q}} ->
                  {AccIn_a, AccIn_r, AddHealth_now, Mtype} = AccIn,

                  if (From_r>=0) ->
                    AccIn_1 = lists:flatten([AccIn_a, "<mod mtype=\"", integer_to_list(Mtype) ,"\" from=\"", integer_to_list(From_r), ":", integer_to_list(From_s), "|", 
                                             integer_to_list(To_r), ":", integer_to_list(To_s), "|", 
                                            integer_to_list(M_id), ":", integer_to_list(M_q),"\" />"]);
                    true -> AccIn_1 = []
                  end,


                
                  AccIn_2 = in_right_panel({From_r, From_s}, {0, 0}, {M_id, M_q}),
                  AccIn_3 = in_right_panel({0, 0}, {To_r, To_s}, {M_id, M_q}),
                  

                  %io:format("AccIn_2: A ~p = ~p~n~n; ", [A, AccIn_2]),



                  % проверить  надо сколько здоровья добавить, если кладем из инвентарь
                  if (((To_r>0) and (From_r==0)) or ((To_r==6) and (To_s==0)) ) -> AddHealth = add_health(M_id);
                    true -> AddHealth = 0
                  end,

                  % проверить  надо сколько здоровья убавить, если убираем в инвентарь, меняем или продаем
                  if (((From_r>0) and (To_r==0)) or ((From_r==6) and (From_s==0)) ) -> DecrHealth = add_health(M_id);
                    true -> DecrHealth = 0
                  end,
                

                  {lists:flatten([AccIn_1, AccIn_3]), lists:flatten([AccIn_r, AccIn_2]), (AddHealth_now+AddHealth-DecrHealth), Mtype};
             _ -> AccIn
        end
    end,
    
    MMI_AD_fun = fun(A, AccIn) ->
        case A of
            {From_a, To_a, M_a} ->
                    lists:delete({To_a, From_a, M_a}, AccIn);
            _ -> AccIn
        end
    end,

    %MMI2 = lists:foldr(MMI_AD_fun, MMI, MMI),

%io:format("MMI2: ~p ~n~n ", [MMI2]),

    {Q2, Q5, AH, _Huy} = lists:foldl(MMI_fun, {[], [], 0, 1}, MMI),

    {Q7, Q8, AH2, _Huy2} = lists:foldl(MMI_fun, {[], [], 0, 2}, MMIO),

    if (Money_m=/=0) -> Q3 = lists:concat(["<money money_m =\"", Money_m ,"\"  />"]);
              true -> Q3 = ""
    end,

    AH0 = AH+AH2,

    if (AH0=/=0) -> Q4 = lists:concat(["<health hp =\"", AH,"\" full_hp=\"-1\"  />"]);
              true -> Q4 = ""
    end,
    

    Q6 = "</err>",
    R_out = lists:flatten([Q1, Q2, Q5, Q3, Q7, Q8, XML_in, Q4, Q6]);

{err, _, _} -> R_out = Result;
          _ -> R_out = Result
end,
R_out.

in_right_panel(From, To, Mod) ->
{From_r, From_s} = From,
{To_r, To_s} = To,
{M_id, M_q} = Mod,

% если 3 то надо привести к такому виду
% <razdel free="2" len="4" name="" num="1">
%    <slot reg="65/1" name="" descr="" src="images/mods/tr-ger.png" sl_gr="1" sl_num="0" id="83" cd="65" allow="0" ready="1" calculated="1" num="100" group="83" send_id="253" back_id=""/>
%  </razdel>



    if (((To_r==3) or (To_r==5)) and (M_id>0)) ->
%<slot reg="0/0" name="" descr="" src="images/mods/tr-ger.png" sl_gr="1" sl_num="0" id="83" cd="65" allow="0" ready="1" calculated="1" num="100" group="83" send_id="253" back_id=""/>

                      case (etanks_mods_info:get_info(M_id, [like_thing, name, descr, icon])) of
                            {Like_thing, Name, Descr, Icon} -> {XmlQ, _X} = xmerl_scan:string(Like_thing),   
                                            QueryAtributes  = etanks_fun:getAtributes(XmlQ, "thing"),
    
                                            % <thing dp="700" duration="200" kd="65" add_health="900" cells_count="100" delay="300" 
                                            % back_id="" send_id="253" group_kd="83" reg="65/1" count="1" param1="30" />
                                            Reg         = etanks_fun:getAttr("reg", QueryAtributes),
                                            Kd          = etanks_fun:getAttr("kd", QueryAtributes),
                                            Group_kd    = etanks_fun:getAttr("group_kd", QueryAtributes),
                                            Send_id     = etanks_fun:getAttr("send_id", QueryAtributes),
                                            Calculated  = to_list(etanks_fun:getAttr("calculated", QueryAtributes)),
                                            Back_id     = etanks_fun:getAttr("back_id", QueryAtributes);

                                       _ ->  Like_thing  = [], 
                                             Name        = [], 
                                             Descr       = [],
                                             Icon        = [],
                                             Reg         = [],
                                             Kd          = [],
                                             Group_kd    = [],
                                             Send_id     = [],
                                             Calculated  = [],
                                             Back_id     = []
                      end;
        true -> Like_thing  = [], 
                Name        = [], 
                Descr       = [],
                Icon        = [],
                Reg         = [],
                Kd          = [],
                Group_kd    = [],
                Send_id     = [],
                Calculated  = [],
                Back_id     = []
    end,

    
        To_PRNum = get_panel_num(To_r),
        From_PRNum = get_panel_num(From_r),

        if (((To_r==3) or (To_r==5)) and (Name =/= [])) -> %lists:flatten(["<mod mtype=\"2\" from=\"", integer_to_list(To_r), ":", integer_to_list(To_s), "|",                                          integer_to_list(M_id), ":", integer_to_list(M_q),"\" />"]);

                                          %io:format("<razdel num=\"1\"><slot reg=\"~p\" name=\"~p\" descr=\"\" src=\"images/mods/~p\" sl_gr=\"1\" sl_num=\"~p\" id=\"~p\" cd=\"~p\" allow=\"0\" ready=\"1\" calculated=\"1\" num=\"~p\" group=\"~p\" send_id=\"~p\" back_id=\"~p\"/></razdel>", [Reg, Name, Icon, integer_to_list(To_s), integer_to_list(M_id), Kd, Cells_count, Group_kd, Send_id, Back_id]),

                                          if (Calculated==[]) -> Cells_count = "1", Calculated_o = "0";
                                                         true -> Calculated_int = list_to_integer(Calculated),
                                                                 if (Calculated_int>1) -> Cells_count = Calculated,
                                                                                          Calculated_o = "1";
                                                                                  true -> Cells_count = to_list(M_q), Calculated_o = Calculated
                                                                 end
                                          end,


                                          lists:flatten(["<panel num=\"", to_list(To_PRNum),"\"><slot reg=\"", to_list(Reg), "\" name=\"", to_list(Name) ,"\" descr=\"", to_list(Descr),"\" src=\"images/mods/", to_list(Icon),"\" sl_gr=\"", to_list(To_PRNum) ,"\" sl_num=\"", to_list(To_s, 0),"\" id=\"", to_list(M_id, 0),"\" cd=\"", to_list(Kd, 0),"\" allow=\"0\" ready=\"1\" calculated=\"", Calculated_o,"\" num=\"", to_list(Cells_count, 0),"\" group=\"", to_list(Group_kd, 0),"\" send_id=\"", to_list(Send_id, 0),"\" back_id=\"", to_list(Back_id, 0),"\"/></panel>"]);
                           ((From_r==3) or (From_r==5)) -> lists:flatten(["<panel num=\"", to_list(From_PRNum) ,"\"><slot reg=\"\" name=\"\" descr=\"\" src=\"\" sl_gr=\"", to_list(From_PRNum) ,"\" sl_num=\"", integer_to_list(From_s),"\" id=\"", to_list(M_id, 0) ,"\" cd=\"\" allow=\"0\" ready=\"0\" calculated=\"0\" num=\"0\" group=\"0\" send_id=\"0\" back_id=\"\"/></panel>"]);
                                          %lists:flatten(["<mod mtype=\"2\" from=\"", integer_to_list(From_r), ":", integer_to_list(From_s), "|0:0\" />"]);
              true -> []
    end
.

get_panel_num(To_r) ->
case (To_r) of
    3 -> 1;
    5 -> 0;
    _ -> 0
end.

to_list(Val) ->
    to_list(Val, [])
.

to_list(Val, Default) ->
    case (Val) of
        M when M == err        -> Default;
        M1 when is_list(M1)    -> M1;
        M2 when is_binary(M2)  -> binary_to_list(M2);
        M3 when is_atom(M3)    -> atom_to_list(M3);
        M4 when is_integer(M4) -> integer_to_list(M4);
                             _ -> Default
    end
.

add_health(M_id) ->
                                MRMF = etanks_mods_info:get_info(M_id, [profile_add_health]),
                                if (MRMF == []) -> AddHealth = 0;
                                           true -> {AddHealth_fb} = MRMF,
                                                   if (AddHealth_fb==err) -> AddHealth = 0;
                                                                     true -> AddHealth = list_to_integer(AddHealth_fb)
                                                   end
                                end,
AddHealth.
