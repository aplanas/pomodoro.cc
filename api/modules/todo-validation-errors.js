const allowedFields = ['id', '_id', 'completed', 'completed_at', 'completedAt', 'created_at', 'createdAt', 'text', 'cancelled', 'cancelled_at']

module.exports = function todoValidationErrors (todo) {
  if (!todo) return ['invalid']
  const errors = []
  const unknownFields = Object.keys(todo).filter(key => !allowedFields.includes(key))
  if (unknownFields.length > 0) errors.push(`unknown fields: ${unknownFields.join(', ')}`)
  if (!todo.text || typeof todo.text !== 'string') errors.push(`"text" needs to be a string (received ${todo.text})`)
  return errors.length === 0 ? null : errors
}