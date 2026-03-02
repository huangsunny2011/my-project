import { useTodos } from './hooks/useTodos';
import './index.css';

/**
 * 待办事项应用主组件
 * 
 * 注意：这是基础版本，展示了 useTodos Hook 的使用方式
 * 请 @Laptop-AI 或 @Office-AI 实现以下组件来完善应用：
 * - TodoInput.jsx - 输入框组件
 * - TodoList.jsx - 列表组件
 * - TodoItem.jsx - 单个待办项组件
 * - TodoFilter.jsx - 过滤器组件
 */
function App() {
  const {
    todos,
    filter,
    stats,
    addTodo,
    toggleTodo,
    deleteTodo,
    editTodo,
    setFilter,
    clearCompleted,
  } = useTodos();

  return (
    <div className="min-h-screen py-8 px-4">
      <div className="max-w-2xl mx-auto">
        {/* 应用标题 */}
        <header className="text-center mb-8">
          <h1 className="text-5xl font-bold text-white mb-2">
            📝 待办事项
          </h1>
          <p className="text-white/80">
            AI 协作演示项目 - Desktop AI 初始版本
          </p>
        </header>

        {/* 主容器 */}
        <div className="bg-white rounded-2xl shadow-2xl overflow-hidden">
          {/* 输入区域 - 临时简化版 */}
          <div className="p-6 border-b border-gray-200">
            <form
              onSubmit={(e) => {
                e.preventDefault();
                const input = e.target.elements.todoInput;
                addTodo(input.value);
                input.value = '';
              }}
              className="flex gap-2"
            >
              <input
                name="todoInput"
                type="text"
                placeholder="输入新的待办事项..."
                className="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
              />
              <button
                type="submit"
                className="px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors font-medium"
              >
                添加
              </button>
            </form>
          </div>

          {/* 待办列表 - 临时简化版 */}
          <div className="divide-y divide-gray-100">
            {todos.length === 0 ? (
              <div className="p-12 text-center text-gray-400">
                <p className="text-xl">✨ 还没有待办事项</p>
                <p className="text-sm mt-2">添加一个开始吧！</p>
              </div>
            ) : (
              todos.map((todo) => (
                <div
                  key={todo.id}
                  className="p-4 hover:bg-gray-50 transition-colors flex items-center gap-3"
                >
                  {/* 复选框 */}
                  <input
                    type="checkbox"
                    checked={todo.completed}
                    onChange={() => toggleTodo(todo.id)}
                    className="w-5 h-5 text-purple-600 rounded focus:ring-purple-500"
                  />
                  
                  {/* 文本 */}
                  <span
                    className={`flex-1 ${
                      todo.completed
                        ? 'line-through text-gray-400'
                        : 'text-gray-800'
                    }`}
                  >
                    {todo.text}
                  </span>

                  {/* 删除按钮 */}
                  <button
                    onClick={() => deleteTodo(todo.id)}
                    className="px-3 py-1 text-red-600 hover:bg-red-50 rounded transition-colors"
                  >
                    删除
                  </button>
                </div>
              ))
            )}
          </div>

          {/* 底部统计和过滤器 */}
          {todos.length > 0 && (
            <div className="p-4 bg-gray-50 flex items-center justify-between flex-wrap gap-4">
              {/* 统计信息 */}
              <div className="text-sm text-gray-600">
                共 {stats.total} 项，
                <span className="text-blue-600 font-medium">
                  {stats.active} 项未完成
                </span>
              </div>

              {/* 过滤器按钮 */}
              <div className="flex gap-2">
                {['all', 'active', 'completed'].map((f) => (
                  <button
                    key={f}
                    onClick={() => setFilter(f)}
                    className={`px-3 py-1 rounded transition-colors ${
                      filter === f
                        ? 'bg-purple-600 text-white'
                        : 'bg-white text-gray-600 hover:bg-gray-100'
                    }`}
                  >
                    {f === 'all' ? '全部' : f === 'active' ? '未完成' : '已完成'}
                  </button>
                ))}
              </div>

              {/* 清除已完成 */}
              {stats.completed > 0 && (
                <button
                  onClick={clearCompleted}
                  className="text-sm text-red-600 hover:text-red-700"
                >
                  清除已完成
                </button>
              )}
            </div>
          )}
        </div>

        {/* 协作提示 */}
        <div className="mt-6 text-center text-white/80 text-sm">
          <p>🤖 这是 Desktop AI 创建的基础版本</p>
          <p className="mt-1">
            请其他 AI 继续完善组件和样式！
          </p>
        </div>
      </div>
    </div>
  );
}

export default App;
