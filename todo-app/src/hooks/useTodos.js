import { useState, useEffect, useCallback } from 'react';
import { getTodos, saveTodos } from '../utils/storage';

/**
 * 待办事项管理 Hook
 * 提供完整的 CRUD 操作和过滤功能
 * 
 * @returns {Object} 包含待办事项数据和操作方法的对象
 */
export const useTodos = () => {
  // 从 localStorage 初始化待办事项列表
  const [todos, setTodos] = useState(() => getTodos());
  
  // 过滤器状态：'all' | 'active' | 'completed'
  const [filter, setFilter] = useState('all');

  // 每次 todos 变化时同步到 localStorage
  useEffect(() => {
    saveTodos(todos);
  }, [todos]);

  /**
   * 添加新的待办事项
   * @param {string} text - 待办事项文本
   */
  const addTodo = useCallback((text) => {
    if (!text.trim()) return;
    
    const newTodo = {
      id: Date.now(), // 使用时间戳作为简单的 ID
      text: text.trim(),
      completed: false,
      createdAt: new Date().toISOString(),
    };
    
    setTodos(prevTodos => [newTodo, ...prevTodos]);
  }, []);

  /**
   * 切换待办事项的完成状态
   * @param {number} id - 待办事项 ID
   */
  const toggleTodo = useCallback((id) => {
    setTodos(prevTodos =>
      prevTodos.map(todo =>
        todo.id === id
          ? { ...todo, completed: !todo.completed }
          : todo
      )
    );
  }, []);

  /**
   * 删除待办事项
   * @param {number} id - 待办事项 ID
   */
  const deleteTodo = useCallback((id) => {
    setTodos(prevTodos => prevTodos.filter(todo => todo.id !== id));
  }, []);

  /**
   * 编辑待办事项文本
   * @param {number} id - 待办事项 ID
   * @param {string} newText - 新的文本内容
   */
  const editTodo = useCallback((id, newText) => {
    if (!newText.trim()) return;
    
    setTodos(prevTodos =>
      prevTodos.map(todo =>
        todo.id === id
          ? { ...todo, text: newText.trim() }
          : todo
      )
    );
  }, []);

  /**
   * 清除所有已完成的待办事项
   */
  const clearCompleted = useCallback(() => {
    setTodos(prevTodos => prevTodos.filter(todo => !todo.completed));
  }, []);

  /**
   * 切换所有待办事项的完成状态
   * @param {boolean} completed - 目标完成状态
   */
  const toggleAll = useCallback((completed) => {
    setTodos(prevTodos =>
      prevTodos.map(todo => ({ ...todo, completed }))
    );
  }, []);

  // 根据过滤器筛选待办事项
  const filteredTodos = todos.filter(todo => {
    if (filter === 'active') return !todo.completed;
    if (filter === 'completed') return todo.completed;
    return true; // 'all'
  });

  // 统计信息
  const stats = {
    total: todos.length,
    active: todos.filter(todo => !todo.completed).length,
    completed: todos.filter(todo => todo.completed).length,
  };

  return {
    // 数据
    todos: filteredTodos,
    allTodos: todos, // 未过滤的完整列表
    filter,
    stats,
    
    // 操作方法
    addTodo,
    toggleTodo,
    deleteTodo,
    editTodo,
    clearCompleted,
    toggleAll,
    setFilter,
  };
};
