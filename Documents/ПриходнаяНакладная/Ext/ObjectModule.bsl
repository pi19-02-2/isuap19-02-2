﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ОстаткиНоменклатуры Приход
	Движения.ОстаткиНоменклатуры.Записывать = Истина;
	Для Каждого ТекСтрокаСписокНоменклатуры Из СписокНоменклатуры Цикл
		Движение = Движения.ОстаткиНоменклатуры.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаСписокНоменклатуры.Номенклатура;
		Движение.Партия = Ссылка;
		Движение.НомерСтрокиПартии = ТекСтрокаСписокНоменклатуры.НомерСтроки;
		Движение.Количество = ТекСтрокаСписокНоменклатуры.Количество;
		Движение.Сумма = ТекСтрокаСписокНоменклатуры.Сумма;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры
