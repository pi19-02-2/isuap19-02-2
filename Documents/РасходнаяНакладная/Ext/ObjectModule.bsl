﻿Процедура ОбработкаПроведения(Отказ, Режим)	
	Для Каждого ТекСтрока Из СписокНоменклатуры Цикл
		Список1 = ПолучитьСписокНоменклатур(Партия, ТекСтрока.Номенклатура);
		ОсталосьСписать = Списать(Список1, ТекСтрока.Количество);
		
		Список2 = ПолучитьСписокНоменклатурСогласноУчетнойПолитике(Партия, ТекСтрока.Номенклатура);
		ОсталосьСписать = Списать(Список2, ОсталосьСписать);
	КонецЦикла;
КонецПроцедуры



Функция ПолучитьСписокНоменклатур(ВключаемаяПартия, Номенклатура)
	Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ОстаткиНоменклатурыОстатки.Партия КАК Партия,
			|	ОстаткиНоменклатурыОстатки.Номенклатура КАК Номенклатура,
			|	ОстаткиНоменклатурыОстатки.КоличествоОстаток КАК КоличествоОстаток,
			|	ОстаткиНоменклатурыОстатки.СуммаОстаток КАК СуммаОстаток,
			|	ОстаткиНоменклатурыОстатки.НомерСтрокиПартии КАК НомерСтрокиПартии
			|ИЗ
			|	РегистрНакопления.ОстаткиНоменклатуры.Остатки(
			|			,
			|			Партия = &Партия
			|				И Номенклатура = &Номенклатура) КАК ОстаткиНоменклатурыОстатки
			|ГДЕ
			|	ОстаткиНоменклатурыОстатки.КоличествоОстаток > 0
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтрокиПартии";
	Запрос.УстановитьПараметр("Партия", ВключаемаяПартия);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();	
	
	Возврат Выборка;
КонецФункции


Функция ПолучитьСписокНоменклатурСогласноУчетнойПолитике(ИсключаемаяПартия, Номенклатура)
	// Получить текстовое представление параметра сортировки запроса
	СортировкаСогласноУчетнойПолитике = "";
	Если УчетнаяПолитика = Перечисления.УчетнаяПолитика.ЛИФО Тогда
		СортировкаСогласноУчетнойПолитике = "УБЫВ";
	ИначеЕсли УчетнаяПолитика = Перечисления.УчетнаяПолитика.ФИФО Тогда
		СортировкаСогласноУчетнойПолитике = "ВОЗР";
	Иначе
		ВызватьИсключение("Неизвестное значение учетной политики.");
	КонецЕсли;
	
	// Получить данные
	Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|  	ОстаткиНоменклатурыОстатки.Партия КАК Партия,        	
			|	ОстаткиНоменклатурыОстатки.Партия.Дата КАК ПартияДата,
			|	ОстаткиНоменклатурыОстатки.Номенклатура КАК Номенклатура,
			|	ОстаткиНоменклатурыОстатки.КоличествоОстаток КАК КоличествоОстаток,
			|	ОстаткиНоменклатурыОстатки.СуммаОстаток КАК СуммаОстаток,
			|	ОстаткиНоменклатурыОстатки.НомерСтрокиПартии КАК НомерСтрокиПартии 
			|ИЗ
			|	РегистрНакопления.ОстаткиНоменклатуры.Остатки(
			|		,
			|		Партия <> &Партия
			|			И Номенклатура = &Номенклатура) КАК ОстаткиНоменклатурыОстатки
			|ГДЕ 
			|	ОстаткиНоменклатурыОстатки.КоличествоОстаток > 0
			|
			|УПОРЯДОЧИТЬ ПО
			|	ПартияДата " + СортировкаСогласноУчетнойПолитике + ",
			|	НомерСтрокиПартии";
	Запрос.УстановитьПараметр("Партия", ИсключаемаяПартия);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();	
	
	Возврат Выборка;
КонецФункции


Функция Списать(Выборка, Количество)
	ОсталосьСписать = Количество;
	Движения.ОстаткиНоменклатуры.Записывать = Истина;
	Пока ОсталосьСписать <> 0 И Выборка.Следующий() Цикл		
		Движение = Движения.ОстаткиНоменклатуры.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Партия = Выборка.Партия;
		Движение.НомерСтрокиПартии = Выборка.НомерСтрокиПартии;
		Движение.Количество = Мин(Выборка.КоличествоОстаток, ОсталосьСписать);
		Движение.Сумма = Выборка.СуммаОстаток / Выборка.КоличествоОстаток * Движение.Количество;
		
		ОсталосьСписать = ОсталосьСписать - Движение.Количество;
	КонецЦикла;
	Возврат ОсталосьСписать;
КонецФункции



Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриходнаяНакладная") Тогда 		
		Партия = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	
	ЭтотОбъект.УчетнаяПолитика = РегистрыСведений.МетодСписания.ПолучитьПоследнее(Дата).МетодСписания;
КонецПроцедуры


Процедура ПриКопировании(ОбъектКопирования)
	ЭтотОбъект.УчетнаяПолитика = РегистрыСведений.МетодСписания.ПолучитьПоследнее(Дата).МетодСписания;
КонецПроцедуры


 



