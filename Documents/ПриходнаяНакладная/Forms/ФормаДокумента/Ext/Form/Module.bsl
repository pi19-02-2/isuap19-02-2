﻿&НаКлиенте
Процедура СписокНоменклатурыКоличествоПриИзменении(Элемент)
	ПересчетСуммыСтрокиДокумента();
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыЦенаПриИзменении(Элемент)
	ПересчетСуммыСтрокиДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПересчетСуммыСтрокиДокумента()
    Сумма=Элементы.СписокНоменклатуры.ТекущиеДанные.Сумма;
    Цена=Элементы.СписокНоменклатуры.ТекущиеДанные.Цена;
    Кол=Элементы.СписокНоменклатуры.ТекущиеДанные.Количество;

    Сумма = Цена * Кол; 

    Элементы.СписокНоменклатуры.ТекущиеДанные.Сумма = Сумма;

    Объект.СуммаПоДокументу = Объект.СписокНоменклатуры.Итог("Сумма");    
КонецПроцедуры