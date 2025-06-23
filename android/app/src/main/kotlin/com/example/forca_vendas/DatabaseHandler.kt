package com.example.forca_vendas

import android.content.ContentValues
import android.content.Context
import android.content.SharedPreferences
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import io.flutter.plugin.common.MethodChannel

class DatabaseHandler(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    private val sharedPreferences: SharedPreferences = context.getSharedPreferences("forca_vendas_prefs", Context.MODE_PRIVATE)

    companion object {
        private const val DATABASE_VERSION = 1
        private const val DATABASE_NAME = "forca_vendas.db"
    }

    override fun onCreate(db: SQLiteDatabase) {
        // Tabelas do banco de dados
        db.execSQL("CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, senha TEXT, ultimaAlteracao TEXT)")
        db.execSQL("CREATE TABLE clientes (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, tipo TEXT, cpfCnpj TEXT, email TEXT, telefone TEXT, cep TEXT, endereco TEXT, bairro TEXT, cidade TEXT, uf TEXT, ultimaAlteracao TEXT)")
        db.execSQL("CREATE TABLE produtos (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, unidade TEXT, qtdEstoque REAL, precoVenda REAL, status INTEGER, custo REAL, codigoBarra TEXT, ultimaAlteracao TEXT)")
        db.execSQL("CREATE TABLE pedidos (id INTEGER PRIMARY KEY AUTOINCREMENT, idCliente INTEGER, idUsuario INTEGER, totalPedido REAL, ultimaAlteracao TEXT)")
        db.execSQL("CREATE TABLE pedido_itens (id INTEGER PRIMARY KEY AUTOINCREMENT, idPedido INTEGER, idProduto INTEGER, quantidade REAL, totalItem REAL)")
        db.execSQL("CREATE TABLE pedido_pagamentos (id INTEGER PRIMARY KEY AUTOINCREMENT, idPedido INTEGER, valor REAL)")
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS usuarios")
        db.execSQL("DROP TABLE IF EXISTS clientes")
        db.execSQL("DROP TABLE IF EXISTS produtos")
        db.execSQL("DROP TABLE IF EXISTS pedidos")
        db.execSQL("DROP TABLE IF EXISTS pedido_itens")
        db.execSQL("DROP TABLE IF EXISTS pedido_pagamentos")
        onCreate(db)
    }

    fun handle(call: io.flutter.plugin.common.MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initDatabase" -> {
                writableDatabase
                result.success(null)
            }
            "saveString" -> {
                val key = call.argument<String>("key")
                val value = call.argument<String>("value")
                if (key != null && value != null) {
                    sharedPreferences.edit().putString(key, value).apply()
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENTS", "Key or value is null", null)
                }
            }
            "loadString" -> {
                val key = call.argument<String>("key")
                if (key != null) {
                    val value = sharedPreferences.getString(key, "")
                    result.success(value)
                } else {
                    result.error("INVALID_ARGUMENTS", "Key is null", null)
                }
            }
            "insert" -> {
                val table = call.argument<String>("table")
                val data = call.argument<Map<String, Any>>("data")
                if (table != null && data != null) {
                    val values = ContentValues().apply {
                        data.forEach { (key, value) ->
                            when (value) {
                                is String -> put(key, value)
                                is Int -> put(key, value)
                                is Long -> put(key, value)
                                is Double -> put(key, value)
                                is Boolean -> put(key, value)
                                else -> put(key, value?.toString())
                            }
                        }
                    }
                    val id = writableDatabase.insert(table, null, values)
                    result.success(id)
                } else {
                    result.error("INVALID_ARGUMENTS", "Table or data is null", null)
                }
            }
            "query" -> {
                val table = call.argument<String>("table")
                val where = call.argument<String>("where")
                val whereArgs = call.argument<List<String>>("whereArgs")
                if (table != null) {
                    val cursor = readableDatabase.query(table, null, where, whereArgs?.toTypedArray(), null, null, null)
                    result.success(cursorToList(cursor))
                } else {
                    result.error("INVALID_ARGUMENTS", "Table is null", null)
                }
            }
            "update" -> {
                val table = call.argument<String>("table")
                val data = call.argument<Map<String, Any>>("data")
                val where = call.argument<String>("where")
                val whereArgs = call.argument<List<String>>("whereArgs")

                if (table != null && data != null && where != null && whereArgs != null) {
                     val values = ContentValues().apply {
                        data.forEach { (key, value) ->
                            when (value) {
                                is String -> put(key, value)
                                is Int -> put(key, value)
                                is Long -> put(key, value)
                                is Double -> put(key, value)
                                is Boolean -> put(key, value)
                                else -> put(key, value?.toString())
                            }
                        }
                    }
                    val count = writableDatabase.update(table, values, where, whereArgs.toTypedArray())
                    result.success(count)
                } else {
                     result.error("INVALID_ARGUMENTS", "Invalid arguments for update", null)
                }
            }
            "delete" -> {
                 val table = call.argument<String>("table")
                 val where = call.argument<String>("where")
                 val whereArgs = call.argument<List<String>>("whereArgs")

                 if (table != null && where != null && whereArgs != null) {
                    val count = writableDatabase.delete(table, where, whereArgs.toTypedArray())
                    result.success(count)
                 } else {
                    result.error("INVALID_ARGUMENTS", "Invalid arguments for delete", null)
                 }
            }
            else -> result.notImplemented()
        }
    }

    private fun cursorToList(cursor: Cursor): List<Map<String, Any?>> {
        val list = mutableListOf<Map<String, Any?>>()
        while (cursor.moveToNext()) {
            val map = mutableMapOf<String, Any?>()
            for (i in 0 until cursor.columnCount) {
                map[cursor.getColumnName(i)] = when (cursor.getType(i)) {
                    Cursor.FIELD_TYPE_NULL -> null
                    Cursor.FIELD_TYPE_INTEGER -> cursor.getLong(i)
                    Cursor.FIELD_TYPE_FLOAT -> cursor.getDouble(i)
                    Cursor.FIELD_TYPE_STRING -> cursor.getString(i)
                    Cursor.FIELD_TYPE_BLOB -> cursor.getBlob(i)
                    else -> null
                }
            }
            list.add(map)
        }
        cursor.close()
        return list
    }
} 