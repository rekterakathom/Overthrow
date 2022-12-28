closedialog 0;
createDialog "OT_dialog_craft";

{
    _x params ["_cls","_recipe","_qty"];
    _idx = 0;
    private _name = _cls call OT_fnc_getClassDisplayName;
    _idx = lbAdd [1500,format["%1 x %2",_qty,_name]];
    lbSetData [1500,_idx,format["%1-%2",_cls,_qty]];
}foreach(OT_craftableItems);
