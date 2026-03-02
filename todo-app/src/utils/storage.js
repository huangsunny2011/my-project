/**
 * localStorage 工具函数
 * 提供类型安全的存储和读取功能
 */

const STORAGE_KEY = 'todos-app-data';

/**
 * 从 localStorage 读取数据
 * @param {string} key - 存储键名（默认为 STORAGE_KEY）
 * @param {any} defaultValue - 默认值
 * @returns {any} 解析后的数据或默认值
 */
export const getFromStorage = (key = STORAGE_KEY, defaultValue = null) => {
  try {
    const item = window.localStorage.getItem(key);
    
    // 如果没有数据，返回默认值
    if (item === null) {
      return defaultValue;
    }
    
    // 尝试解析 JSON
    return JSON.parse(item);
  } catch (error) {
    console.error('读取 localStorage 失败:', error);
    return defaultValue;
  }
};

/**
 * 保存数据到 localStorage
 * @param {string} key - 存储键名（默认为 STORAGE_KEY）
 * @param {any} value - 要存储的数据
 * @returns {boolean} 是否成功
 */
export const saveToStorage = (key = STORAGE_KEY, value) => {
  try {
    // 转换为 JSON 字符串并存储
    const serialized = JSON.stringify(value);
    window.localStorage.setItem(key, serialized);
    return true;
  } catch (error) {
    console.error('保存到 localStorage 失败:', error);
    return false;
  }
};

/**
 * 从 localStorage 删除数据
 * @param {string} key - 存储键名（默认为 STORAGE_KEY）
 * @returns {boolean} 是否成功
 */
export const removeFromStorage = (key = STORAGE_KEY) => {
  try {
    window.localStorage.removeItem(key);
    return true;
  } catch (error) {
    console.error('删除 localStorage 数据失败:', error);
    return false;
  }
};

/**
 * 清空所有 localStorage 数据
 * @returns {boolean} 是否成功
 */
export const clearStorage = () => {
  try {
    window.localStorage.clear();
    return true;
  } catch (error) {
    console.error('清空 localStorage 失败:', error);
    return false;
  }
};

/**
 * 获取待办事项列表
 * @returns {Array} 待办事项数组
 */
export const getTodos = () => {
  return getFromStorage(STORAGE_KEY, []);
};

/**
 * 保存待办事项列表
 * @param {Array} todos - 待办事项数组
 * @returns {boolean} 是否成功
 */
export const saveTodos = (todos) => {
  return saveToStorage(STORAGE_KEY, todos);
};
